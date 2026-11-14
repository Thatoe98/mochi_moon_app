import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/review/application/review_providers.dart';
import 'package:mochi_moon/features/review/domain/review_policy.dart';
import 'package:mochi_moon/features/review/domain/review_repositories.dart';

class _FakeDeck extends Deck {
  _FakeDeck(this._streak);

  final int _streak;

  @override
  Future<DeckState> build() async => DeckState(
    cards: const [],
    position: 0,
    completedToday: 0,
    streak: _streak,
    canUndo: false,
  );
}

class _FakeHistory implements ReviewHistoryRepository {
  _FakeHistory(this.history);

  ReviewHistory history;
  final marked = <DateTime>[];

  @override
  Future<ReviewHistory> load() async => history;

  @override
  Future<void> markAsked(DateTime now) async => marked.add(now);
}

class _FakeService implements ReviewService {
  int requests = 0;

  @override
  Future<void> requestReview() async => requests++;

  @override
  Future<bool> openStoreListing() async => true;
}

void main() {
  final now = DateTime(2026, 11, 14, 20);

  Future<({_FakeHistory history, _FakeService service})> run({
    required int streak,
    Mood? mood,
    ReviewHistory history = const ReviewHistory(),
  }) async {
    final fakeHistory = _FakeHistory(history);
    final service = _FakeService();
    final container = ProviderContainer(
      overrides: [
        deckProvider.overrideWith(() => _FakeDeck(streak)),
        todayMoodProvider.overrideWithValue(mood),
        clockProvider.overrideWithValue(() => now),
        reviewHistoryRepositoryProvider.overrideWithValue(fakeHistory),
        reviewServiceProvider.overrideWithValue(service),
        reviewPromptDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);
    await container.read(maybeAskForReviewProvider)();
    return (history: fakeHistory, service: service);
  }

  test('asks Play and records it when the moment is right', () async {
    final result = await run(streak: 4, mood: Mood.happy);
    expect(result.service.requests, 1);
    expect(result.history.marked, [now]);
  });

  test('does nothing on a short streak', () async {
    final result = await run(streak: 1);
    expect(result.service.requests, 0);
    expect(result.history.marked, isEmpty);
  });

  test('does nothing on a low-mood day', () async {
    final result = await run(streak: 10, mood: Mood.sad);
    expect(result.service.requests, 0);
  });

  test('does nothing when she was asked recently', () async {
    final result = await run(
      streak: 10,
      history: ReviewHistory(
        lastAsked: now.subtract(const Duration(days: 10)),
        timesAsked: 1,
      ),
    );
    expect(result.service.requests, 0);
  });
}
