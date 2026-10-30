import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/data/drift_local_data_eraser.dart';
import 'package:mochi_moon/features/auth/data/firestore_account_remote.dart';
import 'package:mochi_moon/features/auth/data/server_account_remote.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'account_deletion_providers.g.dart';

/// The server deletes the account when the build has a Readings API; without
/// one the app deletes the Firestore data and the Auth user itself.
@Riverpod(keepAlive: true)
AccountRemote accountRemote(Ref ref) {
  final api = ref.watch(readingsApiProvider);
  return api == null ? FirestoreAccountRemote() : ServerAccountRemote(api);
}

@Riverpod(keepAlive: true)
LocalDataEraser localDataEraser(Ref ref) => DriftLocalDataEraser(
  ref.watch(appDatabaseProvider),
  SharedPreferencesAsync(),
);

/// How a deletion ended, for the screen to react to.
enum AccountDeletionOutcome {
  /// Everything is gone; the app should start over.
  deleted,

  /// The user backed out of confirming their Google account. Nothing was
  /// touched and they are still signed in.
  cancelled,

  /// No connection, so the cloud copy could not be removed. Nothing local was
  /// touched; trying again later is safe.
  offline,

  /// Anything else.
  failed,
}

/// Deletes the account from Mochi Moon and wipes this phone. The state is
/// whether a deletion is running.
///
/// The order matters: confirm the Google account first, so backing out of it
/// leaves everything as it was; then cloud data (the rules need the user
/// signed in), then the Auth user, then the local data. The sync providers stop once the
/// user is gone, so nothing recreates the cloud copy afterwards. Signed out,
/// only the local wipe runs, which makes this a full reset for testing.
///
/// With the Readings API the server removes the cloud data and the Auth user
/// in one call, so the app only signs out afterwards.
@Riverpod(keepAlive: true)
class AccountDeletion extends _$AccountDeletion {
  @override
  bool build() => false;

  Future<AccountDeletionOutcome> delete() async {
    if (state) return AccountDeletionOutcome.failed;
    state = true;
    try {
      final auth = ref.read(authRepositoryProvider);
      if (auth.currentUser case final user?) {
        await auth.confirmIdentity();
        final remote = ref.read(accountRemoteProvider);
        await remote.deleteUserData(user.uid);
        await (remote.removesAuthUser ? auth.signOut() : auth.deleteAccount());
      }
      await _cancelNotifications();
      await ref.read(localDataEraserProvider).eraseAll();
      return AccountDeletionOutcome.deleted;
    } on CancelledFailure {
      return AccountDeletionOutcome.cancelled;
    } on NetworkFailure {
      return AccountDeletionOutcome.offline;
    } on Object {
      return AccountDeletionOutcome.failed;
    } finally {
      if (ref.mounted) state = false;
    }
  }

  /// Scheduled notifications outlive the app's data, so clear them too. A
  /// failure here must not stop the deletion.
  Future<void> _cancelNotifications() async {
    try {
      await ref.read(reminderSchedulerProvider).cancelAll();
      await ref.read(retrogradeAlertSchedulerProvider).cancelAll();
    } on Object {
      // The notifications just fire once more at worst.
    }
  }
}
