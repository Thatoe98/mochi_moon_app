import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';

Widget host(Widget child, {double textScale = 1}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  test('every named illustration exists on disk', () {
    for (final asset in AppIllustrations.all) {
      expect(File(asset).existsSync(), isTrue, reason: asset);
    }
  });

  group('forCategory', () {
    test('every category in the content is mapped on purpose', () {
      final json = jsonDecode(
        File('assets/content/quotes/quotes.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final categories = {
        for (final q in json['quotes'] as List<dynamic>)
          (q as Map<String, dynamic>)['category'] as String,
      };

      // A new category must be given art in forCategory and added here, not
      // left to the calm fallback.
      expect(categories, isNotEmpty);
      expect(
        categories.difference(const {
          'calm',
          'confidence',
          'healing',
          'self_love',
          'body_kindness',
          'study_work',
        }),
        isEmpty,
      );
    });

    test('maps the categories as designed', () {
      expect(AppIllustrations.forCategory('calm'), AppIllustrations.calm);
      expect(
        AppIllustrations.forCategory('confidence'),
        AppIllustrations.confidence,
      );
      expect(AppIllustrations.forCategory('healing'), AppIllustrations.healing);
      expect(
        AppIllustrations.forCategory('self_love'),
        AppIllustrations.selfWorth,
      );
      expect(
        AppIllustrations.forCategory('body_kindness'),
        AppIllustrations.selfWorth,
      );
      expect(AppIllustrations.forCategory('study_work'), AppIllustrations.rest);
    });

    test('falls back to calm for an unknown category', () {
      expect(AppIllustrations.forCategory('whatever'), AppIllustrations.calm);
    });
  });

  testWidgets('a quote card wears the art for its category', (tester) async {
    await tester.pumpWidget(
      host(const QuoteCard(text: 'Rest is allowed', category: 'study_work')),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      image.semanticLabel,
      'Mochi the moon bunny sleeping on a soft cloud under a crescent moon',
    );
  });

  testWidgets('a long affirmation shrinks to fit inside the card', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const Center(
          child: SizedBox(
            width: 290,
            height: 435,
            child: QuoteCard(
              text:
                  'I choose to speak to myself like someone I love, and I '
                  'give myself the same patience I would give a dear friend '
                  'on a hard day.',
              category: 'self_love',
              categoryLabel: 'Self-love',
            ),
          ),
        ),
        textScale: 1.3,
      ),
    );
    await tester.pump();

    final card = tester.getRect(find.byType(QuoteCard));
    final text = tester.getRect(find.textContaining('I choose to speak'));
    expect(card.contains(text.topLeft), isTrue);
    expect(card.contains(text.bottomRight), isTrue);
    final chip = tester.getRect(find.text('Self-love'));
    expect(text.bottom, lessThanOrEqualTo(chip.top));
  });

  testWidgets('empty state shows the art with its label', (tester) async {
    await tester.pumpWidget(
      host(
        const EmptyState(
          title: 'Nothing saved yet',
          illustration: AppIllustrations.emptyDeck,
          illustrationLabel: 'Mochi on a moon',
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.semanticLabel, 'Mochi on a moon');
    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('empty state without art keeps the icon', (tester) async {
    await tester.pumpWidget(host(const EmptyState(title: 'Nothing here')));

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
  });

  testWidgets('empty state with art fits a small screen at 1.3x text', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(600, 900)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        const EmptyState(
          title: 'Nothing saved yet',
          body: 'Swipe right on the cards you love and they will live here.',
          illustration: AppIllustrations.emptyDeck,
          illustrationLabel: 'Mochi on a moon',
        ),
        textScale: 1.3,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
