import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/app/app_restart.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/account_deletion_providers.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/auth/presentation/delete_account_section.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../cosmic/retrograde/support/fake_alerts.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_account.dart';
import '../support/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late FakeAccountRemote remote;
  late FakeLocalDataEraser eraser;
  late int restarts;

  setUp(() {
    auth = FakeAuthRepository(
      signedIn: const AuthUser(uid: 'uid_1', displayName: 'Mochi'),
    );
    remote = FakeAccountRemote();
    eraser = FakeLocalDataEraser();
    restarts = 0;
  });

  Widget host({double textScale = 1}) => ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      accountRemoteProvider.overrideWithValue(remote),
      localDataEraserProvider.overrideWithValue(eraser),
      reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
      retrogradeAlertSchedulerProvider.overrideWithValue(
        FakeRetrogradeAlertScheduler(),
      ),
      appRestartProvider.overrideWithValue(() => restarts++),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const Scaffold(body: DeleteAccountSection()),
    ),
  );

  testWidgets('asks first, and keeping the account changes nothing', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsOneWidget);

    await tester.tap(find.text('Keep my account'));
    await tester.pumpAndSettle();

    expect(remote.deleted, isEmpty);
    expect(eraser.erased, 0);
    expect(restarts, 0);
  });

  testWidgets('confirming deletes everything and restarts the app', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(remote.deleted, ['uid_1']);
    expect(auth.currentUser, isNull);
    expect(eraser.erased, 1);
    expect(restarts, 1);
  });

  testWidgets('offline shows a message and keeps the app as it is', (
    tester,
  ) async {
    remote.error = const NetworkFailure();
    await tester.pumpWidget(host());

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.textContaining('offline'), findsOneWidget);
    expect(restarts, 0);
    expect(eraser.erased, 0);
  });

  testWidgets('a failure shows a message', (tester) async {
    auth.deleteError = const UnknownFailure('boom');
    await tester.pumpWidget(host());

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.textContaining('nothing was deleted'), findsOneWidget);
    expect(restarts, 0);
  });

  testWidgets('backing out of the Google check says nothing', (tester) async {
    auth.deleteError = const CancelledFailure();
    await tester.pumpWidget(host());

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
    expect(restarts, 0);
  });

  testWidgets('survives 1.3x text without overflow', (tester) async {
    await tester.pumpWidget(host(textScale: 1.3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
