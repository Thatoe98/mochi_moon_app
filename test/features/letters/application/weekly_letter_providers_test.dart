import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/weekly_letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../settings/support/fake_reminder.dart';
import '../support/fake_weekly_letter.dart';

// Sunday 1 Nov 2026: the letter is about 26 Oct - 1 Nov.
final _sunday = DateTime(2026, 11, 1, 20);
final _monday = DateTime(2026, 10, 26);

WeekAggregates _busy() => buildWeekAggregates(
  weekStart: _monday,
  moods: [DayMood(day: _monday, mood: Mood.happy)],
  ritualDays: [_monday],
  questDoneDays: const [],
);

WeekAggregates _empty() => buildWeekAggregates(
  weekStart: _monday,
  moods: const [],
  ritualDays: const [],
  questDoneDays: const [],
);

ProviderContainer _container({
  required FakeWeeklyLetterRepository repo,
  bool premium = true,
  WeekAggregates? week,
  FakeWeeklyLetterNotifier? notifier,
  FakeReminderScheduler? scheduler,
}) {
  final container = ProviderContainer(
    overrides: [
      hasPremiumProvider.overrideWithValue(premium),
      clockProvider.overrideWithValue(() => _sunday),
      effectiveLanguageProvider.overrideWithValue('en'),
      reminderLanguageProvider.overrideWithValue('en'),
      weekAggregatesProvider.overrideWithValue(week ?? _busy()),
      weeklyLetterRepositoryProvider.overrideWithValue(repo),
      weeklyLetterSchedulerProvider.overrideWithValue(
        notifier ?? FakeWeeklyLetterNotifier(),
      ),
      reminderSchedulerProvider.overrideWithValue(
        scheduler ?? FakeReminderScheduler(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('weeklyLetter', () {
    test('a free user gets nothing and no call is made', () async {
      final repo = FakeWeeklyLetterRepository();
      final view = await _container(
        repo: repo,
        premium: false,
      ).read(weeklyLetterProvider.future);

      expect(view, isNull);
      expect(repo.asked, isEmpty);
    });

    test('Premium gets the letter the server wrote', () async {
      final repo = FakeWeeklyLetterRepository();
      final view = await _container(repo: repo)
          .read(weeklyLetterProvider.future);

      expect(view!.isFallback, isFalse);
      expect(view.letter.title, 'Server title');
      expect(repo.asked.single.weekStart, _monday);
    });

    test('a saved letter is shown without asking the server', () async {
      const saved = WeeklyLetter(
        weekStart: '2026-10-26',
        lang: 'en',
        version: 1,
        title: 'Saved',
        body: 'Saved body.',
      );
      final repo = FakeWeeklyLetterRepository(saved: saved);
      final view = await _container(repo: repo)
          .read(weeklyLetterProvider.future);

      expect(view!.letter, saved);
      expect(repo.asked, isEmpty);
    });

    test('offline shows the bundled fallback, marked as such', () async {
      final repo = FakeWeeklyLetterRepository(
        error: const ReadingsApiException(status: 500, code: 'x'),
      );
      final view = await _container(repo: repo)
          .read(weeklyLetterProvider.future);

      expect(view!.isFallback, isTrue);
      expect(view.letter.title, isNotEmpty);
      expect(view.letter.body, isNotEmpty);
      expect(view.letter.weekStart, '2026-10-26');
    });

    test(
      'an empty week with nothing saved makes no call and no card',
      () async {
        final repo = FakeWeeklyLetterRepository();
        final view = await _container(
          repo: repo,
          week: _empty(),
        ).read(weeklyLetterProvider.future);

        expect(view, isNull);
        expect(repo.asked, isEmpty);
      },
    );
  });

  group('weeklyLetterNotificationsSync', () {
    test('Premium with permission plans the next four Sundays', () async {
      final notifier = FakeWeeklyLetterNotifier();
      final container = _container(
        repo: FakeWeeklyLetterRepository(),
        notifier: notifier,
        scheduler: FakeReminderScheduler()..granted = true,
      );
      await container.read(weeklyLetterNotificationsSyncProvider.future);

      expect(notifier.at, [
        DateTime(2026, 11, 8, 18),
        DateTime(2026, 11, 15, 18),
        DateTime(2026, 11, 22, 18),
        DateTime(2026, 11, 29, 18),
      ]);
      // The text only says a letter is ready; it never carries the letter.
      expect(notifier.texts!.title, isNotEmpty);
      expect(notifier.texts!.body, isNotEmpty);
    });

    test('a free user has the notifications cancelled', () async {
      final notifier = FakeWeeklyLetterNotifier();
      final container = _container(
        repo: FakeWeeklyLetterRepository(),
        premium: false,
        notifier: notifier,
        scheduler: FakeReminderScheduler()..granted = true,
      );
      await container.read(weeklyLetterNotificationsSyncProvider.future);

      expect(notifier.at, isEmpty);
    });

    test('without notification permission nothing is planned', () async {
      final notifier = FakeWeeklyLetterNotifier();
      final container = _container(
        repo: FakeWeeklyLetterRepository(),
        notifier: notifier,
      );
      await container.read(weeklyLetterNotificationsSyncProvider.future);

      expect(notifier.at, isEmpty);
    });
  });
}
