import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/weekly_letter_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/quests/application/quest_providers.dart';
import 'package:mochi_moon/features/quests/domain/quest_day.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../letters/support/fake_weekly_letter.dart';
import '../../profile/support/fake_profile.dart';
import '../support/fake_quest.dart';

final List<Quest> _quests = [
  for (var i = 1; i <= 6; i++)
    Quest(id: 'q$i', text: {'en': 'Quest $i'}, focusAreas: const ['calm']),
];

ProviderContainer _container(
  FakeQuestRepository repo, {
  DateTime Function()? clock,
  FakeQuestRemote? remote,
  bool signedIn = false,
  bool premium = true,
}) {
  final container = ProviderContainer(
    overrides: [
      questRepositoryProvider.overrideWithValue(repo),
      hasPremiumProvider.overrideWithValue(premium),
      questDoneLogProvider.overrideWithValue(FakeQuestDoneLog()),
      questRemoteProvider.overrideWithValue(remote),
      profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
      profileRemoteProvider.overrideWithValue(null),
      questsProvider.overrideWith((ref) async => _quests),
      clockProvider.overrideWithValue(clock ?? () => DateTime(2026, 11, 2, 9)),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          signedIn: signedIn ? const AuthUser(uid: 'u1') : null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<TodayQuest?> _today(ProviderContainer container) async {
  container.listen(todayQuestProvider, (_, _) {});
  await container.read(questsProvider.future);
  await container.read(savedQuestDayProvider.future);
  await pumpEventQueue();
  final today = container.read(todayQuestProvider);
  return today;
}

void main() {
  test('shows the same quest all day', () async {
    final morning = await _today(
      _container(FakeQuestRepository(), clock: () => DateTime(2026, 11, 2, 7)),
    );
    final night = await _today(
      _container(FakeQuestRepository(), clock: () => DateTime(2026, 11, 2, 23)),
    );

    expect(morning?.quest.id, night?.quest.id);
    expect(morning?.done, isFalse);
    expect(morning?.canSwap, isTrue);
  });

  test('finishing marks it done and removes the swap', () async {
    final repo = FakeQuestRepository();
    final container = _container(repo);
    final before = await _today(container);

    await container.read(completeQuestProvider)();
    await pumpEventQueue();
    final after = container.read(todayQuestProvider)!;

    expect(after.quest.id, before!.quest.id);
    expect(after.done, isTrue);
    expect(after.canSwap, isFalse);
    expect(repo.saved?.done, isTrue);
  });

  test('a free user cannot swap', () async {
    final repo = FakeQuestRepository();
    final container = _container(repo, premium: false);
    final before = await _today(container);

    await container.read(swapQuestProvider)();
    await pumpEventQueue();

    expect(container.read(todayQuestProvider)!.quest.id, before!.quest.id);
    expect(repo.saved, isNull);
  });

  test('Premium swaps once to a different quest, and not again', () async {
    final repo = FakeQuestRepository();
    final container = _container(repo);
    final before = await _today(container);

    await container.read(swapQuestProvider)();
    await pumpEventQueue();
    final swapped = container.read(todayQuestProvider)!;
    expect(swapped.quest.id, isNot(before!.quest.id));
    expect(swapped.canSwap, isFalse);

    await container.read(swapQuestProvider)();
    await pumpEventQueue();
    expect(container.read(todayQuestProvider)!.quest.id, swapped.quest.id);
  });

  test('a finished day does not carry over to the next day', () async {
    var now = DateTime(2026, 11, 2, 9);
    final repo = FakeQuestRepository();
    final container = _container(repo, clock: () => now);
    await _today(container);
    await container.read(completeQuestProvider)();
    await pumpEventQueue();

    now = DateTime(2026, 11, 3, 9);
    container.invalidate(todayQuestProvider);
    final next = container.read(todayQuestProvider)!;

    expect(next.done, isFalse);
    expect(next.canSwap, isTrue);
  });

  test('uploads the quest state and restores one from Firestore', () async {
    final repo = FakeQuestRepository();
    final remote = FakeQuestRemote();
    final container = _container(repo, remote: remote, signedIn: true)
      ..listen(questSyncProvider, (_, _) {});
    await container.read(questSyncProvider.future);
    await _today(container);

    await container.read(completeQuestProvider)();
    await pumpEventQueue();
    expect(remote.stored['u1']?.done, isTrue);

    final fresh = FakeQuestRepository();
    final restored = _container(
      fresh,
      remote: FakeQuestRemote({
        'u1': const QuestDay(date: '2026-11-02', questId: 'q3', done: true),
      }),
      signedIn: true,
    )..listen(questSyncProvider, (_, _) {});
    await restored.read(questSyncProvider.future);

    expect(fresh.saved?.questId, 'q3');
  });
}
