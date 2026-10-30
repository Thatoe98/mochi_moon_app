import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/profile_repository.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/profile/presentation/profile_edit_screen.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../support/fake_profile.dart';

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

/// A repository whose load never finishes, or always fails.
class _StuckRepository extends FakeProfileRepository {
  _StuckRepository({this.fails = false});

  final bool fails;

  @override
  Future<UserProfile?> load() => fails
      ? Future.error(Exception('boom'))
      : Completer<UserProfile?>().future;
}

/// Stands in for the Me tab: it opens the form once, so Save has a screen to
/// pop back to.
class _Me extends StatefulWidget {
  const _Me();

  @override
  State<_Me> createState() => _MeState();
}

class _MeState extends State<_Me> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    if (!_opened) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(context.push('/profile'));
      });
    }
    return const Scaffold(body: Text('me'));
  }
}

final _saved = UserProfile(
  displayName: 'Mochi',
  birthDate: DateTime(1998, 11, 8),
  focusAreas: const [FocusArea.calm],
);

Widget _app(ProfileRepository repository) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _Me()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileEditScreen(),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
      profileRemoteProvider.overrideWithValue(null),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 30, 9)),
      cityIndexProvider.overrideWith((ref) async => CityIndex(_cities)),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

FilledButton _save(WidgetTester tester) =>
    tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));

/// Picks November 25, 1998 in the date dialog (opens on the year list).
Future<void> _pickBirthday(WidgetTester tester) async {
  await _tap(tester, 'Born Nov 8, 1998');
  await tester.tap(find.text('1998'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('25'));
  await tester.pumpAndSettle();
  await _tap(tester, 'OK');
}

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(800, 5000)
      ..devicePixelRatio = 1;
    addTearDown(() {
      binding.platformDispatcher.views.first
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });
  });

  testWidgets('shows a loading state while the profile loads', (tester) async {
    await tester.pumpWidget(_app(_StuckRepository()));
    await tester.pump();
    await tester.pump();

    expect(find.byType(LoadingView), findsOneWidget);
  });

  testWidgets('shows an error state that can retry', (tester) async {
    await tester.pumpWidget(_app(_StuckRepository(fails: true)));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('loads the saved answers and keeps Save off', (tester) async {
    await tester.pumpWidget(_app(FakeProfileRepository(_saved)));
    await tester.pumpAndSettle();

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Mochi'), findsOneWidget);
    expect(find.text('Born Nov 8, 1998'), findsOneWidget);
    expect(find.textContaining('Born at'), findsNothing);
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Calm'))
          .selected,
      isTrue,
    );
    expect(_save(tester).onPressed, isNull);
  });

  testWidgets('changing the name turns Save on, and undoing it turns it off', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeProfileRepository(_saved)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Moon');
    await tester.pump();
    expect(_save(tester).onPressed, isNotNull);

    await tester.enterText(find.byType(TextField).first, 'Mochi');
    await tester.pump();
    expect(_save(tester).onPressed, isNull);
  });

  testWidgets('an empty name blocks Save', (tester) async {
    await tester.pumpWidget(_app(FakeProfileRepository(_saved)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.pump();

    expect(_save(tester).onPressed, isNull);
  });

  testWidgets('saving stores the trimmed name and goes back', (tester) async {
    final repository = FakeProfileRepository(_saved);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '  Moon ');
    await tester.pump();
    await _tap(tester, 'Save');

    expect(repository.profile!.displayName, 'Moon');
    expect(repository.profile!.birthDate, DateTime(1998, 11, 8));
    expect(find.text('me'), findsOneWidget);
    expect(find.text('Profile updated.'), findsOneWidget);
  });

  testWidgets('a new birthday is saved and changes the Sun sign', (
    tester,
  ) async {
    final repository = FakeProfileRepository(_saved);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileEditScreen)),
    );
    final before = await container.read(natalChartProvider.future);
    expect(before!.placementOf(Body.sun).sign, ZodiacSign.scorpio);

    await _pickBirthday(tester);
    await _tap(tester, 'Save');

    expect(repository.profile!.birthDate, DateTime(1998, 11, 25));
    final after = await container.read(natalChartProvider.future);
    expect(after!.placementOf(Body.sun).sign, ZodiacSign.sagittarius);
  });

  testWidgets('a time without a place asks for the place and blocks Save', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeProfileRepository(_saved)));
    await tester.pumpAndSettle();

    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');

    expect(
      find.text(
        'Add a birthplace so we can read the birth time in the right '
        'time zone.',
      ),
      findsOneWidget,
    );
    expect(_save(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField).last, 'bang');
    await tester.pumpAndSettle();
    await _tap(tester, 'Bangkok, Bangkok, Thailand');

    expect(_save(tester).onPressed, isNotNull);
  });

  testWidgets('saving a time and place stores both', (tester) async {
    final repository = FakeProfileRepository(_saved);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    await tester.enterText(find.byType(TextField).last, 'bang');
    await tester.pumpAndSettle();
    await _tap(tester, 'Bangkok, Bangkok, Thailand');
    await _tap(tester, 'Save');

    final profile = repository.profile!;
    expect(profile.birthMinutes, 12 * 60);
    expect(profile.birthPlace?.name, 'Bangkok');
    expect(profile.birthPlace?.tzId, 'Asia/Bangkok');
  });

  testWidgets('"I don\'t know" clears the chosen time', (tester) async {
    final withTime = _saved.copyWith(birthMinutes: 8 * 60);
    await tester.pumpWidget(_app(FakeProfileRepository(withTime)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Born at'), findsOneWidget);

    await _tap(tester, "I don't know");

    expect(find.textContaining('Born at'), findsNothing);
    expect(_save(tester).onPressed, isNotNull);
  });

  testWidgets('at most three focus areas can be chosen', (tester) async {
    await tester.pumpWidget(_app(FakeProfileRepository(_saved)));
    await tester.pumpAndSettle();

    await _tap(tester, 'Healing');
    await _tap(tester, 'Confidence');

    final selfLove = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, 'Self-love'),
    );
    expect(selfLove.onSelected, isNull);
    expect(_save(tester).onPressed, isNotNull);
  });

  testWidgets('a failed save shows a message and stays on the form', (
    tester,
  ) async {
    final repository = FakeProfileRepository(_saved)
      ..saveError = Exception('disk');
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Moon');
    await tester.pump();
    await _tap(tester, 'Save');

    expect(find.text("Couldn't save that. Please try again."), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('me'), findsNothing);
    expect(_save(tester).onPressed, isNotNull);
  });
}
