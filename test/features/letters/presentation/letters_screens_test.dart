import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';
import 'package:mochi_moon/features/letters/presentation/letter_screen.dart';
import 'package:mochi_moon/features/letters/presentation/letters_screen.dart';
import 'package:mochi_moon/features/letters/presentation/write_letter_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../settings/support/fake_reminder.dart';
import '../support/fake_letter.dart';

final _now = DateTime(2026, 11, 2, 9);

FutureLetter _letter(String id, String body, DateTime writtenAt, int days) =>
    sealLetter(id: id, text: body, unlockDays: days, now: writtenAt);

Widget _app(
  FakeLetterRepository repo, {
  String start = '/me/letters',
  bool premium = false,
  List<String>? paywallSources,
}) => ProviderScope(
  overrides: [
    hasPremiumProvider.overrideWithValue(premium),
    letterRepositoryProvider.overrideWithValue(repo),
    letterRemoteProvider.overrideWithValue(null),
    letterSchedulerProvider.overrideWithValue(FakeLetterNotifier()),
    reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    clockProvider.overrideWithValue(() => _now),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(
          path: '/paywall',
          builder: (context, state) {
            paywallSources?.add(state.uri.queryParameters['source']!);
            return const Scaffold(body: Text('paywall'));
          },
        ),
        GoRoute(
          path: '/me/letters',
          builder: (context, state) => const LettersScreen(),
          routes: [
            GoRoute(
              path: 'write',
              builder: (context, state) => const WriteLetterScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  LetterScreen(letterId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ),
);

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2400)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('with no letters it invites her to write one', (tester) async {
    await tester.pumpWidget(_app(FakeLetterRepository()));
    await tester.pumpAndSettle();

    expect(find.text('No letters yet'), findsOneWidget);
    expect(find.text('Write a letter'), findsOneWidget);
  });

  testWidgets('a sealed letter shows its date but never its text', (
    tester,
  ) async {
    final sealed = _letter('a', 'My private words', _now, 30);
    await tester.pumpWidget(_app(FakeLetterRepository([sealed])));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sealed until'), findsOneWidget);
    expect(find.textContaining('My private words'), findsNothing);

    await tester.tap(find.textContaining('Sealed until'));
    await tester.pumpAndSettle();

    expect(find.textContaining('This letter is sealed'), findsOneWidget);
    expect(find.textContaining('My private words'), findsNothing);
  });

  testWidgets('a free user with a sealed letter gets a gentle note, not the '
      'editor', (tester) async {
    final sources = <String>[];
    final repo = FakeLetterRepository([_letter('a', 'x', _now, 30)]);
    await tester.pumpWidget(_app(repo, paywallSources: sources));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Write a letter'));
    await tester.pumpAndSettle();
    expect(find.text('Your free letter is still sealed'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('See Premium'));
    await tester.pumpAndSettle();
    expect(sources, ['letters']);
  });

  testWidgets('an opened letter frees the slot', (tester) async {
    final old = _letter('a', 'x', DateTime(2026, 9), 30);
    await tester.pumpWidget(_app(FakeLetterRepository([old])));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Write a letter'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Premium can write while another letter is sealed', (
    tester,
  ) async {
    final repo = FakeLetterRepository([_letter('a', 'x', _now, 30)]);
    await tester.pumpWidget(_app(repo, premium: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Write a letter'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('an opened letter can be read', (tester) async {
    final old = _letter('a', 'My private words', DateTime(2026, 9), 30);
    await tester.pumpWidget(_app(FakeLetterRepository([old])));
    await tester.pumpAndSettle();
    expect(find.text('Ready to open'), findsOneWidget);

    await tester.tap(find.text('Ready to open'));
    await tester.pumpAndSettle();

    expect(find.text('My private words'), findsOneWidget);
  });

  testWidgets('writing and sealing stores the letter after a confirm', (
    tester,
  ) async {
    final repo = FakeLetterRepository();
    await tester.pumpWidget(_app(repo, start: '/me/letters/write'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), 'Be proud of me');
    await tester.pump();
    await tester.tap(find.text('90 days'));
    await tester.pump();
    await tester.tap(find.text('Seal the letter'));
    await tester.pumpAndSettle();
    expect(find.text('Seal this letter?'), findsOneWidget);
    expect(repo.all, isEmpty);

    await tester.tap(find.text('Seal it'));
    await tester.pumpAndSettle();

    expect(repo.all.single.body, 'Be proud of me');
    expect(repo.all.single.unlockDays, 90);
  });

  testWidgets('deleting a letter asks first', (tester) async {
    final repo = FakeLetterRepository([_letter('a', 'x', _now, 30)]);
    await tester.pumpWidget(_app(repo, start: '/me/letters/a'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete this letter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(repo.all, hasLength(1));

    await tester.tap(find.text('Delete this letter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(repo.all, isEmpty);
  });
}
