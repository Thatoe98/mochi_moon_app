import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/partners/application/compat_report_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/compat_report_repository.dart';
import 'package:mochi_moon/features/partners/presentation/compat_report_screen.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../profile/support/fake_profile.dart';
import '../support/fake_partners.dart';

class _FakeRepository implements CompatReportRepository {
  final controller = StreamController<NatalReport>.broadcast();
  final asked = <String>[];

  @override
  Stream<NatalReport> report({
    required String partnerId,
    required NatalChart you,
    required NatalChart them,
    required Synastry synastry,
    required String lang,
  }) {
    asked.add(partnerId);
    return controller.stream;
  }
}

NatalReport _report(ReportStatus status, int parts) => NatalReport(
  reportId: 'b' * 32,
  lang: 'en',
  version: 1,
  status: status,
  total: 5,
  sections: [
    for (var i = 0; i < parts; i++)
      ReportSection(
        key: 'overview',
        title: 'Part title $i',
        body: 'Part body $i.',
      ),
  ],
);

final _profile = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
  birthMinutes: 8 * 60 + 30,
  birthPlace: bangkok,
);

Widget _host(
  _FakeRepository repository, {
  String? id = 'a',
  UserProfile? profile,
  List<String>? opened,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => CompatReportScreen(partnerId: id),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        builder: (context, state) {
          opened?.add(state.uri.queryParameters['source']!);
          return const Scaffold(body: Text('paywall'));
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(profile),
      ),
      partnerRepositoryProvider.overrideWithValue(
        FakePartnerRepository([partner('a')]),
      ),
      compatReportRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

void main() {
  late _FakeRepository repository;
  setUp(() => repository = _FakeRepository());
  tearDown(() => repository.controller.close());

  void tallView(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(800, 5000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows the parts as they arrive', (tester) async {
    tallView(tester);
    await tester.pumpWidget(_host(repository, profile: _profile));
    await _settle(tester);

    expect(find.text('Writing your reading'), findsOneWidget);
    expect(repository.asked, ['a']);

    repository.controller.add(_report(ReportStatus.generating, 2));
    await tester.pump();
    expect(find.text('Part title 1'), findsOneWidget);

    repository.controller.add(_report(ReportStatus.ready, 5));
    await tester.pump();
    expect(find.text('Part title 4'), findsOneWidget);
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('a 402 becomes a soft invitation to Premium', (tester) async {
    tallView(tester);
    final opened = <String>[];
    await tester.pumpWidget(
      _host(repository, profile: _profile, opened: opened),
    );
    await _settle(tester);

    repository.controller.addError(
      const ReadingsApiException(status: 402, code: 'premium_required'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Try again'), findsNothing);
    await tester.tap(find.text('See Premium'));
    await tester.pumpAndSettle();
    expect(opened, ['server_402']);
  });

  testWidgets('asks for a birth date when there is none', (tester) async {
    tallView(tester);
    await tester.pumpWidget(_host(repository));
    await _settle(tester);

    expect(find.text('Add your birthday to compare'), findsOneWidget);
    expect(repository.asked, isEmpty);
  });

  testWidgets('an unknown partner shows a not-found message', (tester) async {
    tallView(tester);
    await tester.pumpWidget(
      _host(repository, id: 'missing', profile: _profile),
    );
    await _settle(tester);

    expect(find.text("We couldn't find this partner."), findsOneWidget);
    expect(repository.asked, isEmpty);
  });

  testWidgets('a missing id shows a not-found message', (tester) async {
    tallView(tester);
    await tester.pumpWidget(_host(repository, id: null, profile: _profile));
    await tester.pump();

    expect(find.text("We couldn't find this partner."), findsOneWidget);
  });
}
