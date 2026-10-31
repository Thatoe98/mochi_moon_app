import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/auth/domain/auth_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_journey.dart';

final List<Journey> _journeys = [
  for (final id in ['confidence', 'calm'])
    Journey(
      id: id,
      days: 2,
      title: {'en': id},
      summary: {'en': id},
      illustrationId: 'ill_$id',
      daysPlan: [
        for (var day = 1; day <= 2; day++)
          JourneyDayPlan(
            day: day,
            quoteIds: const ['a', 'b', 'c'],
            questId: 'k',
            reflection: const {'en': 'Reflect'},
          ),
      ],
    ),
];

ProviderContainer _container(
  FakeJourneyRepository repo, {
  DateTime Function()? clock,
  FakeJourneyRemote? remote,
  bool signedIn = false,
}) {
  final container = ProviderContainer(
    overrides: [
      journeyRepositoryProvider.overrideWithValue(repo),
      journeyRemoteProvider.overrideWithValue(remote),
      journeysProvider.overrideWith((ref) async => _journeys),
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

void main() {
  test('starts one journey and refuses a second while it is going', () async {
    final repo = FakeJourneyRepository();
    final container = _container(repo);

    await container.read(startJourneyActionProvider)('confidence');
    await container.read(startJourneyActionProvider)('calm');

    expect(repo.saved('confidence')?.currentDay, 1);
    expect(repo.saved('calm'), isNull);
  });

  test('ignores an unknown journey id', () async {
    final repo = FakeJourneyRepository();
    await _container(repo).read(startJourneyActionProvider)('nope');
    expect(repo.saved('nope'), isNull);
  });

  test('finishing days keeps going after a break, then completes', () async {
    var now = DateTime(2026, 11, 2, 9);
    final repo = FakeJourneyRepository();
    final container = _container(repo, clock: () => now);
    await container.read(startJourneyActionProvider)('confidence');
    await container.read(completeJourneyDayProvider)(
      'confidence',
      reflection: 'felt good',
    );
    expect(repo.saved('confidence')?.currentDay, 2);

    // Same day: nothing more.
    await container.read(completeJourneyDayProvider)('confidence');
    expect(repo.saved('confidence')?.completedDays, [1]);

    // A week later she picks up exactly where she stopped.
    now = DateTime(2026, 11, 9, 9);
    await container.read(completeJourneyDayProvider)('confidence');
    final run = repo.saved('confidence')!;
    expect(run.completedDays, [1, 2]);
    expect(run.isFinished, isTrue);
    expect(run.reflections, {1: 'felt good'});
  });

  test('uploads progress and restores it on another device', () async {
    final repo = FakeJourneyRepository();
    final remote = FakeJourneyRemote();
    final container = _container(repo, remote: remote, signedIn: true)
      ..listen(journeySyncProvider, (_, _) {});
    await container.read(journeySyncProvider.future);

    await container.read(startJourneyActionProvider)('confidence');
    await pumpEventQueue();
    expect(remote.stored['u1']?['confidence']?.currentDay, 1);

    final fresh = FakeJourneyRepository();
    final restored = _container(
      fresh,
      remote: FakeJourneyRemote({
        'u1': {
          'confidence': JourneyProgress(
            journeyId: 'confidence',
            startedAt: DateTime(2026, 11),
            currentDay: 2,
            completedDays: const [1],
          ),
        },
      }),
      signedIn: true,
    )..listen(journeySyncProvider, (_, _) {});
    await restored.read(journeySyncProvider.future);

    expect(fresh.saved('confidence')?.completedDays, [1]);
  });
}
