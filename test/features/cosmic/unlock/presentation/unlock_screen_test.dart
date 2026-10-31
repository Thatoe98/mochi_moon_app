import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/cosmic/unlock/presentation/cosmic_locked_view.dart';
import 'package:mochi_moon/features/cosmic/unlock/presentation/unlock_screen.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../../auth/support/fake_auth_repository.dart';
import '../../../profile/support/fake_profile.dart';

const _cities = [
  City(
    name: 'Bangkok',
    asciiName: 'Bangkok',
    region: 'Bangkok',
    countryCode: 'TH',
    countryName: 'Thailand',
    lat: 13.7540,
    lng: 100.5014,
    population: 5104476,
  ),
];

class _Harness {
  _Harness({UserProfile? saved = const UserProfile(displayName: 'Mochi')})
    : profiles = FakeProfileRepository(saved);

  final FakeProfileRepository profiles;

  Widget build({double textScale = 1}) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: CosmicLockedView(title: 'Locked', body: 'Open it up'),
          ),
        ),
        GoRoute(
          path: AppRoutes.cosmicUnlock,
          builder: (context, state) => const UnlockScreen(),
        ),
        GoRoute(
          path: AppRoutes.cosmic,
          builder: (context, state) => const Scaffold(body: Text('Cosmic!')),
        ),
      ],
    );
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        profileRepositoryProvider.overrideWithValue(profiles),
        profileRemoteProvider.overrideWithValue(null),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
        cityIndexProvider.overrideWith((ref) async => CityIndex(_cities)),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
  }
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester, _Harness harness) async {
  await tester.pumpWidget(harness.build());
  await tester.pumpAndSettle();
  await _tap(tester, 'Unlock');
}

Future<void> _pickBirthday(WidgetTester tester) async {
  await _tap(tester, '1998');
  await _tap(tester, '15');
}

FilledButton _mainButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton));

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
  });

  testWidgets('the locked view opens the unlock flow', (tester) async {
    await _open(tester, _Harness());

    expect(find.text('When is your birthday?'), findsOneWidget);
  });

  testWidgets('Continue waits for a birth date', (tester) async {
    await _open(tester, _Harness());

    expect(_mainButton(tester).onPressed, isNull);

    await _pickBirthday(tester);

    expect(_mainButton(tester).onPressed, isNotNull);
    expect(find.textContaining('Born '), findsOneWidget);
  });

  testWidgets('a birth time can be chosen and then dropped', (tester) async {
    await _open(tester, _Harness());
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');

    expect(find.text("No birth time. That's okay."), findsOneWidget);

    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    expect(find.textContaining('Born at'), findsOneWidget);

    await _tap(tester, "I don't know");
    expect(find.text("No birth time. That's okay."), findsOneWidget);
  });

  testWidgets('the birthplace is optional without a birth time', (
    tester,
  ) async {
    await _open(tester, _Harness());
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Continue');

    expect(find.text('Where were you born?'), findsOneWidget);
    expect(_mainButton(tester).onPressed, isNotNull);
  });

  testWidgets('the birthplace is required once a birth time is given', (
    tester,
  ) async {
    await _open(tester, _Harness());
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    await _tap(tester, 'Continue');

    expect(_mainButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'bang');
    await tester.pumpAndSettle();
    await _tap(tester, 'Bangkok, Bangkok, Thailand');

    expect(_mainButton(tester).onPressed, isNotNull);
  });

  testWidgets('finishing saves the birth data and opens Cosmic', (
    tester,
  ) async {
    final harness = _Harness();
    await _open(tester, harness);
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    await _tap(tester, 'Continue');
    await tester.enterText(find.byType(TextField), 'bangkok');
    await tester.pumpAndSettle();
    await _tap(tester, 'Bangkok, Bangkok, Thailand');
    await _tap(tester, 'Unlock Cosmic');

    final saved = harness.profiles.profile!;
    expect(saved.displayName, 'Mochi');
    expect(saved.birthDate, DateTime(1998, 1, 15));
    expect(saved.birthMinutes, isNotNull);
    expect(
      saved.birthPlace,
      const BirthPlace(
        name: 'Bangkok',
        region: 'Bangkok',
        countryCode: 'TH',
        lat: 13.7540,
        lng: 100.5014,
        tzId: 'Asia/Bangkok',
      ),
    );
    expect(find.text('Cosmic!'), findsOneWidget);
  });

  testWidgets('leaving half way saves nothing', (tester) async {
    final harness = _Harness();
    await _open(tester, harness);
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(harness.profiles.profile?.birthDate, isNull);
    expect(find.text('Locked'), findsOneWidget);
  });

  testWidgets('a failed save keeps her on the last step', (tester) async {
    final harness = _Harness();
    await _open(tester, harness);
    await _pickBirthday(tester);
    await _tap(tester, 'Continue');
    await _tap(tester, 'Continue');
    harness.profiles.saveError = Exception('disk full');
    await _tap(tester, 'Unlock Cosmic');

    expect(find.text('Cosmic!'), findsNothing);
    expect(find.text('Where were you born?'), findsOneWidget);
    expect(_mainButton(tester).onPressed, isNotNull);
  });

  testWidgets('fits at 1.3x text', (tester) async {
    await tester.pumpWidget(_Harness().build(textScale: 1.3));
    await tester.pumpAndSettle();
    await _tap(tester, 'Unlock');

    expect(tester.takeException(), isNull);
  });
}
