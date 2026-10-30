import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/presentation/partner_edit_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';

import '../support/fake_partners.dart';

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

/// Stands in for the partners list: it opens the form once, so Save has a
/// screen to pop back to.
class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    if (!_opened) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(context.push('/edit'));
      });
    }
    return const Text('list');
  }
}

Widget _app(
  FakePartnerRepository repository, {
  String? id,
  bool premium = true,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _List()),
      GoRoute(
        path: '/edit',
        builder: (context, state) => PartnerEditScreen(partnerId: id),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      partnerRepositoryProvider.overrideWithValue(repository),
      hasPremiumProvider.overrideWithValue(premium),
      partnerIdGeneratorProvider.overrideWithValue(() => 'new-id'),
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

/// Picks January 14, 1998 in the date dialog (opens on the year list).
Future<void> _pickBirthday(WidgetTester tester) async {
  await _tap(tester, 'Choose a date');
  await tester.tap(find.text('1998'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('14'));
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

  testWidgets('Save stays off until there is a nickname and a birthday', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();
    expect(find.text('Add a partner'), findsOneWidget);
    expect(_save(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, 'Luna');
    await tester.pump();
    expect(_save(tester).onPressed, isNull);

    await _pickBirthday(tester);
    expect(_save(tester).onPressed, isNotNull);
  });

  testWidgets('shows a light-reading hint until a time is chosen', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();

    expect(find.textContaining('light reading'), findsOneWidget);
  });

  testWidgets('a time without a place asks for the place and blocks Save', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Luna');
    await _pickBirthday(tester);

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

  testWidgets('"I don\'t know" clears the chosen time', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();

    await _tap(tester, 'Choose a time');
    await _tap(tester, 'OK');
    expect(find.textContaining('Born at'), findsOneWidget);

    await _tap(tester, "I don't know");
    expect(find.textContaining('Born at'), findsNothing);
    expect(find.text('Choose a time'), findsOneWidget);
  });

  testWidgets('saving adds the partner and goes back', (tester) async {
    final repository = FakePartnerRepository();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '  Luna ');
    await _pickBirthday(tester);

    await _tap(tester, 'Save');

    expect(repository.saved, hasLength(1));
    final saved = repository.saved.single;
    expect(saved.id, 'new-id');
    expect(saved.nickname, 'Luna');
    expect(saved.birthDate, DateTime(1998, 1, 14));
    expect(saved.birthMinutes, isNull);
    expect(saved.createdAt, DateTime(2026, 10, 30, 9));
    expect(find.text('list'), findsOneWidget);
  });

  testWidgets('editing loads the partner and keeps its id and created date', (
    tester,
  ) async {
    final repository = FakePartnerRepository([partner('a', day: 3)]);
    await tester.pumpWidget(_app(repository, id: 'a'));
    await tester.pumpAndSettle();

    expect(find.text('Edit partner'), findsOneWidget);
    expect(find.text('Luna'), findsOneWidget);
    expect(_save(tester).onPressed, isNotNull);

    await tester.enterText(find.byType(TextField).first, 'Sol');
    await tester.pump();
    await _tap(tester, 'Save');

    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.id, 'a');
    expect(repository.saved.single.nickname, 'Sol');
    expect(repository.saved.single.createdAt, DateTime(2026, 10, 3));
  });

  testWidgets('an unknown id shows a not-found message', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository(), id: 'missing'));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't find this partner."), findsOneWidget);
  });

  testWidgets('a Free user at the limit gets a message, not a second partner', (
    tester,
  ) async {
    final repository = FakePartnerRepository([partner('a')]);
    await tester.pumpWidget(_app(repository, premium: false));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Sol');
    await _pickBirthday(tester);

    await _tap(tester, 'Save');

    expect(find.text("You've reached the partner limit."), findsOneWidget);
    expect(repository.saved, hasLength(1));
    expect(find.text('Add a partner'), findsOneWidget);
  });

  testWidgets('the nickname field stops at 30 characters', (tester) async {
    await tester.pumpWidget(_app(FakePartnerRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'x' * 40);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField).first);
    expect(field.controller!.text.length, 30);
  });
}
