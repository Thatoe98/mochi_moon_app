import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/partners/data/drift_partner_repository.dart';
import 'package:mochi_moon/features/partners/data/firestore_partner_remote.dart';
import 'package:mochi_moon/features/partners/data/partner_codec.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_repository.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_providers.g.dart';

@Riverpod(keepAlive: true)
PartnerRepository partnerRepository(Ref ref) =>
    DriftPartnerRepository(ref.watch(appDatabaseProvider));

/// The Firestore copy, or null when Firebase did not start.
@Riverpod(keepAlive: true)
PartnerRemote? partnerRemote(Ref ref) =>
    ref.watch(firebaseReadyProvider) ? FirestorePartnerRemote() : null;

/// Makes the id of a new partner. Overridden in tests.
@Riverpod(keepAlive: true)
String Function() partnerIdGenerator(Ref ref) {
  final random = math.Random.secure();
  return () =>
      List.generate(16, (_) => random.nextInt(16).toRadixString(16)).join();
}

/// Keeps the partners in Firestore in step with the device while someone is
/// signed in, the same way as the journal: the device is the source of truth,
/// every change is applied here first and mirrored afterwards. Edits are
/// noticed by comparing what was last sent for each partner.
///
/// On start, partners that only Firestore has (a reinstall, another phone) are
/// added here. A removal that could not be sent is not remembered, so that
/// partner comes back the next time the app opens. Watched from the app root.
@Riverpod(keepAlive: true)
Future<void> partnerSync(Ref ref) async {
  final user = await ref.watch(authUserProvider.future);
  final remote = ref.watch(partnerRemoteProvider);
  if (user == null || remote == null) return;
  final uid = user.uid;
  final repository = ref.watch(partnerRepositoryProvider);

  String signature(Partner partner) => jsonEncode(partnerToMap(partner));

  // What Firestore is known to hold, by id.
  final mirrored = <String, String>{};
  try {
    final stored = await remote.fetch(uid);
    for (final partner in stored) {
      mirrored[partner.id] = signature(partner);
    }
    final local = {for (final p in await repository.partners()) p.id};
    await repository.addMissing([
      for (final partner in stored)
        if (!local.contains(partner.id)) partner,
    ]);
  } on AppFailure catch (error) {
    debugPrint('Could not read the partners from Firestore: $error');
  }

  var busy = false;
  var again = false;
  Future<void> mirror() async {
    // One pass at a time; a change that arrives meanwhile is picked up by the
    // pass that follows.
    if (busy) {
      again = true;
      return;
    }
    busy = true;
    try {
      do {
        again = false;
        final current = await repository.partners();
        final ids = {for (final p in current) p.id};
        for (final partner in current) {
          final sent = signature(partner);
          if (mirrored[partner.id] == sent) continue;
          try {
            await remote.put(uid, partner);
            mirrored[partner.id] = sent;
          } on AppFailure catch (error) {
            debugPrint('Could not save a partner to Firestore: $error');
          }
        }
        for (final id
            in mirrored.keys.where((id) => !ids.contains(id)).toList()) {
          try {
            await remote.delete(uid, id);
            mirrored.remove(id);
          } on AppFailure catch (error) {
            debugPrint('Could not remove a partner from Firestore: $error');
          }
        }
      } while (again);
    } finally {
      busy = false;
    }
  }

  final subscription = repository.watch().listen((_) => mirror());
  ref.onDispose(subscription.cancel);
}

/// The saved partners, oldest first.
@riverpod
class Partners extends _$Partners {
  @override
  Future<List<Partner>> build() =>
      ref.watch(partnerRepositoryProvider).partners();

  /// A new partner's id and creation time, for the form to fill in.
  ({String id, DateTime createdAt}) startNew() => (
    id: ref.read(partnerIdGeneratorProvider)(),
    createdAt: ref.read(clockProvider)(),
  );

  /// Saves [partner] as new or as an edit of the one with the same id.
  /// Throws [PartnerLimitReached] when a new one would go over the limit.
  Future<void> save(Partner partner) async {
    final repository = ref.read(partnerRepositoryProvider);
    final current = await repository.partners();
    final isNew = current.every((p) => p.id != partner.id);
    final limit = partnerLimit(hasPremium: ref.read(hasPremiumProvider));
    if (isNew && current.length >= limit) throw PartnerLimitReached(limit);
    await repository.save(partner);
    state = AsyncData(await repository.partners());
  }

  Future<void> remove(String id) async {
    final repository = ref.read(partnerRepositoryProvider);
    await repository.remove(id);
    state = AsyncData(await repository.partners());
  }
}

/// Whether one more partner can be saved: false once the Free or Premium
/// limit is reached.
@riverpod
bool canAddPartner(Ref ref) {
  final partners = ref.watch(partnersProvider).value;
  if (partners == null) return false;
  return partners.length <
      partnerLimit(hasPremium: ref.watch(hasPremiumProvider));
}
