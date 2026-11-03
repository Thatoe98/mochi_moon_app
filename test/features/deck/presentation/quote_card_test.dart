import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';

const _text = 'I am allowed to ask for a hug, a call, or some space.';

Widget _host({required double cardHeight, double textScale = 1}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 340,
        height: cardHeight,
        child: const QuoteCard(
          text: _text,
          category: 'healing',
          categoryLabel: 'Healing',
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('a roomy card shows the text and the category chip', (
    tester,
  ) async {
    await tester.pumpWidget(_host(cardHeight: 520));

    expect(find.text(_text), findsOneWidget);
    expect(find.text('Healing'), findsOneWidget);
  });

  testWidgets('a short card still shows a readable affirmation', (
    tester,
  ) async {
    // About the card height on a 16:9 phone, where the text used to vanish.
    await tester.pumpWidget(_host(cardHeight: 178));

    final box = tester.getRect(find.text(_text));
    final fitted = tester.getRect(
      find.ancestor(of: find.text(_text), matching: find.byType(FittedBox)),
    );
    expect(find.text(_text), findsOneWidget);
    // The text area is not squeezed to nothing.
    expect(fitted.height, greaterThan(24));
    expect(box.height, greaterThan(0));
    // The chip makes way instead of the words.
    expect(find.text('Healing'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a short card with large text does not overflow', (
    tester,
  ) async {
    await tester.pumpWidget(_host(cardHeight: 178, textScale: 1.3));

    expect(find.text(_text), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
