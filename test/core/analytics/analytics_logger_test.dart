import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';

import '../../features/settings/support/fake_analytics_consent.dart';

ProviderContainer _container({
  required bool? consent,
  required RecordingAnalyticsSink sink,
}) {
  final container = ProviderContainer(
    overrides: [
      analyticsConsentRepositoryProvider.overrideWithValue(
        FakeAnalyticsConsentRepository(saved: consent),
      ),
      analyticsSinkProvider.overrideWithValue(sink),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('AnalyticsLogger', () {
    test('logs nothing until the user has answered', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: null, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await container
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.cardCompleted);

      expect(sink.recorded, isEmpty);
    });

    test('logs nothing after the user declines', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: false, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await container
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.cardCompleted);

      expect(sink.recorded, isEmpty);
    });

    test('delivers events once the user allows', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: true, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await container
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.cardCompleted);

      expect(sink.recorded, hasLength(1));
      expect(sink.recorded.single.$1, 'card_completed');
    });

    test('starts delivering as soon as consent is granted', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: null, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);
      final logger = container.read(analyticsLoggerProvider);

      await logger.log(AnalyticsEvent.cardShared);
      await container
          .read(analyticsConsentControllerProvider.notifier)
          .set(granted: true);
      await logger.log(AnalyticsEvent.cardShared);

      expect(sink.recorded, hasLength(1));
    });

    test('stops delivering as soon as consent is withdrawn', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: true, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);
      final logger = container.read(analyticsLoggerProvider);

      await container
          .read(analyticsConsentControllerProvider.notifier)
          .set(granted: false);
      await logger.log(AnalyticsEvent.cardShared);

      expect(sink.recorded, isEmpty);
    });

    test('keeps only the parameters an event allows', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: true, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await container
          .read(analyticsLoggerProvider)
          .log(
            AnalyticsEvent.cardSwiped,
            params: {'direction': 'right', 'quoteText': 'I am enough.'},
          );
      await container
          .read(analyticsLoggerProvider)
          .log(AnalyticsEvent.cardShared, params: {'birthDate': '2000-01-01'});

      expect(sink.recorded.map((e) => e.$1), ['card_swiped', 'card_shared']);
      expect(sink.recorded[0].$2, {'direction': 'right'});
      expect(sink.recorded[1].$2, isEmpty);
    });

    test('swallows a failing sink', () async {
      final sink = RecordingAnalyticsSink(failWith: Exception('offline'));
      final container = _container(consent: true, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await expectLater(
        container
            .read(analyticsLoggerProvider)
            .log(AnalyticsEvent.cardCompleted),
        completes,
      );
    });
  });

  group('AnalyticsEvent', () {
    test('no event can carry text she wrote, birth data or names', () {
      // Every param is a count, a day, a stored id or a mood id.
      const allowed = {
        'source',
        'direction',
        'count',
        'mood',
        'journeyId',
        'day',
        'unlockDays',
        'itemId',
        'mode',
        'productId',
        'type',
      };
      final used = {for (final e in AnalyticsEvent.values) ...e.allowedParams};
      expect(used.difference(allowed), isEmpty);
    });

    test('the new feature events log, dropping any unlisted param', () async {
      final sink = RecordingAnalyticsSink();
      final container = _container(consent: true, sink: sink);
      await container.read(analyticsConsentControllerProvider.future);

      await container
          .read(analyticsLoggerProvider)
          .log(
            AnalyticsEvent.gratitudeAdded,
            params: {'count': '2', 'text': 'my private line'},
          );

      expect(sink.recorded.single.$1, 'gratitude_added');
      expect(sink.recorded.single.$2, {'count': '2'});
    });

    test('event names are unique snake_case', () {
      final names = AnalyticsEvent.values.map((e) => e.eventName).toList();
      expect(names.toSet(), hasLength(names.length));
      for (final name in names) {
        expect(name, matches(RegExp(r'^[a-z]+(_[a-z]+)*$')));
      }
    });
  });
}
