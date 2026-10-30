import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/cosmic/report/application/natal_report_providers.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report_repository.dart';
import 'package:mochi_moon/features/cosmic/report/presentation/natal_report_screen.dart';

class _FakeRepository implements NatalReportRepository {
  // Broadcast, so a retry can listen again and closing never waits for a listener.
  final controller = StreamController<NatalReport>.broadcast();
  int asked = 0;

  @override
  Stream<NatalReport> report({
    required NatalChart chart,
    required String lang,
  }) {
    asked++;
    return controller.stream;
  }
}

NatalReport _report(ReportStatus status, int parts, {int total = 3}) =>
    NatalReport(
      reportId: 'a' * 32,
      lang: 'en',
      version: 1,
      status: status,
      total: total,
      sections: [
        for (var i = 0; i < parts; i++)
          ReportSection(
            key: i == 0 ? 'overview' : 'love',
            title: 'Part title $i',
            body: 'Part body $i.',
          ),
      ],
    );

final NatalChart _chart = computeNatalChart(
  BirthData(
    birthDate: DateTime(1998, 11, 8),
    birthMinutes: 510,
    tzId: 'Asia/Bangkok',
    latitude: 13.75,
    longitude: 100.5,
  ),
);

Widget _host(
  NatalReportRepository repository, {
  bool noBirthDate = false,
  Locale? locale,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    natalChartProvider.overrideWith((ref) async => noBirthDate ? null : _chart),
    natalReportRepositoryProvider.overrideWithValue(repository),
  ],
  child: MaterialApp(
    theme: AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const NatalReportScreen(),
  ),
);

void _tallView(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 5000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Lets the chart load so the screen is listening to the report.
Future<void> _listen(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeRepository repository;
  setUp(() => repository = _FakeRepository());
  tearDown(() => repository.controller.close());

  testWidgets('shows a preparing note before the first part arrives', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_host(repository));
    await _listen(tester);

    expect(find.text('Writing your reading'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows parts as they arrive, with progress and a writing tile', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_host(repository));
    await _listen(tester);

    repository.controller.add(_report(ReportStatus.generating, 1));
    await tester.pump();

    expect(find.text('Part title 0'), findsOneWidget);
    expect(find.text('Part body 0.'), findsOneWidget);
    expect(find.text('1 of 3 parts ready · about 2 min read'), findsOneWidget);
    expect(find.text('Writing the next part…'), findsOneWidget);

    repository.controller.add(_report(ReportStatus.ready, 3));
    await tester.pump();

    expect(find.text('Part title 2'), findsOneWidget);
    expect(find.text('Writing the next part…'), findsNothing);
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('a failed report keeps its parts and offers to try again', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_host(repository));
    await _listen(tester);

    repository.controller.add(_report(ReportStatus.failed, 2));
    await tester.pump();

    expect(find.text('Part title 1'), findsOneWidget);
    expect(find.text('Some parts did not finish'), findsOneWidget);
    expect(find.text('Writing the next part…'), findsNothing);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(repository.asked, 2);
  });

  testWidgets('a broken wait after some parts keeps them and offers retry', (
    tester,
  ) async {
    _tallView(tester);
    await tester.pumpWidget(_host(repository));
    await _listen(tester);

    repository.controller
      ..add(_report(ReportStatus.generating, 1))
      ..addError(const NetworkFailure());
    await tester.pump();
    await tester.pump();

    expect(find.text('Part title 0'), findsOneWidget);
    expect(find.text('Some parts did not finish'), findsOneWidget);
  });

  for (final (error, title, button) in <(Object, String, bool)>[
    (const NetworkFailure(), "You're offline", true),
    (const UnavailableFailure(), 'Something wobbled', false),
    (
      const ReadingsApiException(status: 429, code: 'rate_limited'),
      'Something wobbled',
      true,
    ),
  ]) {
    testWidgets('shows a message for ${error.runtimeType}', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(_host(repository));
      await _listen(tester);

      repository.controller.addError(error);
      await tester.pump();
      await tester.pump();

      expect(find.text(title), findsOneWidget);
      expect(find.text('Try again'), button ? findsOneWidget : findsNothing);
    });
  }

  testWidgets('asks for a birth date when there is none', (tester) async {
    await tester.pumpWidget(_host(repository, noBirthDate: true));
    await _listen(tester);
    await tester.pump();

    expect(find.text('Your chart needs a birth date'), findsOneWidget);
    expect(repository.asked, 0);
  });

  testWidgets('fits at 1.3x text and reads in Burmese', (tester) async {
    _tallView(tester);
    await tester.pumpWidget(
      _host(repository, locale: const Locale('my'), textScale: 1.3),
    );
    await _listen(tester);

    repository.controller.add(_report(ReportStatus.generating, 2));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Part title 1'), findsOneWidget);
    expect(find.text('Writing the next part…'), findsNothing);
  });
}
