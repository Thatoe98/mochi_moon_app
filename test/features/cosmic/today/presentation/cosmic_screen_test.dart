import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/presentation/cosmic_screen.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading_repository.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../../../support/disk_bundle.dart';
import '../../../profile/support/fake_profile.dart';
import '../support/fake_thai_colors_setting.dart';

class _FailingReadings implements DailyReadingRepository {
  int calls = 0;

  @override
  Future<DailyReading> readingFor({
    required ZodiacSign sign,
    required DateTime date,
    required String lang,
  }) async {
    calls++;
    throw const NetworkFailure();
  }
}

final _scorpio = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
);

Widget _host({
  UserProfile? profile,
  FakeThaiColorsSettingRepository? thai,
  DailyReadingRepository? readings,
  Locale? locale,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    profileRepositoryProvider.overrideWithValue(FakeProfileRepository(profile)),
    contentRepositoryProvider.overrideWithValue(
      AssetContentRepository(bundle: DiskBundle()),
    ),
    thaiColorsSettingRepositoryProvider.overrideWithValue(
      thai ?? FakeThaiColorsSettingRepository(),
    ),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 29, 12)),
    if (readings != null)
      dailyReadingRepositoryProvider.overrideWithValue(readings),
  ],
  child: MaterialApp(
    theme: AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const CosmicScreen(),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows a loader first', (tester) async {
    await tester.pumpWidget(_host(profile: _scorpio));
    expect(find.byType(LoadingView), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('asks for a birth date when there is none', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();
    expect(find.text('Your stars need a date'), findsOneWidget);
    expect(find.text('For entertainment and self-reflection'), findsNothing);
  });

  testWidgets('shows today for the sun sign', (tester) async {
    // Tall enough that the whole list is built, so the art above does not
    // push the first blocks out of the lazy list.
    tester.view
      ..physicalSize = const Size(800, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_host(profile: _scorpio));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Image>(find.byType(Image)).semanticLabel,
      contains('Scorpio costume'),
    );
    expect(find.textContaining('Scorpio'), findsWidgets);
    expect(find.textContaining('Moon in'), findsOneWidget);
    expect(find.text('Your depth is a superpower'), findsOneWidget);
    expect(find.text("Today's energy"), findsOneWidget);
    expect(find.text('Love'), findsOneWidget);
    expect(find.text('Lucky colors'), findsOneWidget);
    expect(find.text('Berry'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Lucky number'), 300);
    expect(find.text('8'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('For entertainment and self-reflection'),
      300,
    );
    expect(find.text('Things to avoid'), findsOneWidget);
    expect(find.text('For entertainment and self-reflection'), findsOneWidget);
  });

  testWidgets('hides the Thai colors unless they are switched on', (
    tester,
  ) async {
    await tester.pumpWidget(_host(profile: _scorpio));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('For entertainment and self-reflection'),
      300,
    );
    expect(find.text('Thai colors'), findsNothing);
  });

  testWidgets('shows the birthday and day colors when switched on', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        profile: _scorpio,
        thai: FakeThaiColorsSettingRepository(saved: true),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Thai colors'), 300);
    await tester.scrollUntilVisible(
      find.text('For entertainment and self-reflection'),
      300,
    );

    expect(find.bySemanticsLabel(RegExp('Your birthday color: Red')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp("Today's color: Orange")), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('shows English text when the language has none', (tester) async {
    await tester.pumpWidget(
      _host(profile: _scorpio, locale: const Locale('th')),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Your depth is a superpower'),
      300,
    );
    expect(find.text('Your depth is a superpower'), findsOneWidget);
  });

  testWidgets('shows an error with a retry that asks again', (tester) async {
    final readings = _FailingReadings();
    await tester.pumpWidget(_host(profile: _scorpio, readings: readings));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    final before = readings.calls;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(readings.calls, greaterThan(before));
  });

  testWidgets('fits at 1.3x text size on a small phone', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        profile: _scorpio,
        thai: FakeThaiColorsSettingRepository(saved: true),
        textScale: 1.3,
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('For entertainment and self-reflection'),
      300,
    );
    expect(tester.takeException(), isNull);
  });
}
