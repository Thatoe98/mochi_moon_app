import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/journal/domain/journal_repository.dart';
import 'package:mochi_moon/features/journal/presentation/journal_screen.dart';

import '../../custom_cards/support/fake_own_cards.dart';
import '../../deck/support/fake_image_sharer.dart';
import '../support/fake_journal_repository.dart';

const _quotes = [
  Quote(id: 'a', text: {'en': 'I am enough'}, category: 'self_love'),
  Quote(id: 'b', text: {'en': 'I can rest'}, category: 'calm'),
  Quote(id: 'c', text: {'en': 'I am growing'}, category: 'self_love'),
];

JournalEntry _entry(String id, int day) =>
    JournalEntry(quoteId: id, savedAt: DateTime(2026, 10, day));

Widget _app(
  FakeJournalRepository repo, {
  FakeImageSharer? sharer,
  Future<List<Quote>> Function()? loadQuotes,
}) => ProviderScope(
  overrides: [
    journalRepositoryProvider.overrideWithValue(repo),
    imageSharerProvider.overrideWithValue(sharer ?? FakeImageSharer()),
    ownCardRepositoryProvider.overrideWithValue(FakeOwnCardRepository()),
    quotesProvider.overrideWith(
      (ref) => loadQuotes?.call() ?? Future.value(_quotes),
    ),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: JournalScreen(),
  ),
);

void main() {
  testWidgets('shows a loading state while quotes load', (tester) async {
    await tester.pumpWidget(
      _app(
        FakeJournalRepository(),
        loadQuotes: () =>
            Future.delayed(const Duration(seconds: 1), () => _quotes),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows the empty state when nothing is saved', (tester) async {
    await tester.pumpWidget(_app(FakeJournalRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
    expect(
      find.text("Swipe right on the cards you love and they'll live here."),
      findsOneWidget,
    );
  });

  testWidgets('shows an error state that retries', (tester) async {
    var fail = true;
    await tester.pumpWidget(
      _app(
        FakeJournalRepository([_entry('a', 1)]),
        loadQuotes: () => fail ? Future.error(Exception('boom')) : _loaded(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Something wobbled'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('I am enough'), findsOneWidget);
  });

  testWidgets('lists saved cards newest first', (tester) async {
    await tester.pumpWidget(
      _app(
        FakeJournalRepository([_entry('a', 1), _entry('b', 3), _entry('c', 2)]),
      ),
    );
    await tester.pumpAndSettle();

    final texts = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title! as Text).data);
    expect(texts, ['I can rest', 'I am growing', 'I am enough']);
  });

  testWidgets('skips a saved card that is no longer in the content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(FakeJournalRepository([_entry('a', 1), _entry('retired', 2)])),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('filters by category', (tester) async {
    await tester.pumpWidget(
      _app(
        FakeJournalRepository([_entry('a', 1), _entry('b', 2), _entry('c', 3)]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Calm'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('I can rest'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('hides the filter when only one category is saved', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(FakeJournalRepository([_entry('a', 1), _entry('c', 2)])),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('tapping a card opens it in full', (tester) async {
    await tester.pumpWidget(_app(FakeJournalRepository([_entry('a', 1)])));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('I am enough'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('the full card can be reshared', (tester) async {
    final sharer = FakeImageSharer();
    await tester.pumpWidget(
      _app(FakeJournalRepository([_entry('a', 1)]), sharer: sharer),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share'));
    await tester.runAsync(() async {
      for (var i = 0; i < 50 && sharer.shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });

    expect(sharer.shared.single.fileName, 'mochi_moon_a.png');
    // The card stays open so she can share again or close it.
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('long-press asks before removing, then removes', (tester) async {
    final repo = FakeJournalRepository([_entry('a', 1), _entry('b', 2)]);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('I am enough'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(find.text('I am enough'), findsOneWidget);
    expect(repo.saved, hasLength(2));

    await tester.longPress(find.text('I am enough'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('I am enough'), findsNothing);
    expect(repo.saved.map((e) => e.quoteId), ['b']);
  });

  testWidgets('removing the last card shows the empty state', (tester) async {
    await tester.pumpWidget(_app(FakeJournalRepository([_entry('a', 1)])));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('I am enough'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('copes with text scaled to 1.3x', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: _app(FakeJournalRepository([_entry('a', 1), _entry('b', 2)])),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

Future<List<Quote>> _loaded() async => _quotes;
