import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';
import 'package:mochi_moon/features/deck/presentation/share_image_renderer.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';

import '../support/fake_image_sharer.dart';

const _quote = Quote(
  id: 'q1',
  text: {'en': 'I am enough', 'my': 'ကျွန်မ လုံလောက်ပါတယ်'},
  category: 'self_love',
);

/// A single button that runs [onPressed] with a context that has an overlay.
Widget _host(
  FakeImageSharer sharer,
  void Function(BuildContext, WidgetRef) onPressed, {
  double textScale = 1,
  Locale locale = const Locale('en'),
}) => ProviderScope(
  overrides: [imageSharerProvider.overrideWithValue(sharer)],
  child: MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: Scaffold(
      body: Consumer(
        builder: (context, ref, _) => TextButton(
          onPressed: () => onPressed(context, ref),
          child: const Text('go'),
        ),
      ),
    ),
  ),
);

/// Rendering needs a real event loop and one pumped frame.
Future<T> _runWithFrame<T>(
  WidgetTester tester,
  Future<T> Function() body,
) async {
  late T result;
  await tester.runAsync(() async {
    final future = body();
    await tester.pump();
    result = await future;
  });
  return result;
}

Future<ui.Image> _decode(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  return (await codec.getNextFrame()).image;
}

void main() {
  group('renderShareImage', () {
    testWidgets('produces a 1080x1920 PNG', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(_host(FakeImageSharer(), (c, _) => context = c));
      await tester.tap(find.text('go'));

      final png = await _runWithFrame(
        tester,
        () => renderShareImage(
          context,
          const ShareCardImage(
            text: 'I am enough',
            category: 'self_love',
            wordmark: 'Mochi Moon',
          ),
        ),
      );
      final image = (await tester.runAsync(() => _decode(png)))!;

      expect(image.width, 1080);
      expect(image.height, 1920);
    });

    testWidgets('ignores the user text scale and leaves nothing mounted', (
      tester,
    ) async {
      late BuildContext context;
      await tester.pumpWidget(
        _host(FakeImageSharer(), (c, _) => context = c, textScale: 2),
      );
      await tester.tap(find.text('go'));

      final png = await _runWithFrame(
        tester,
        () => renderShareImage(
          context,
          const ShareCardImage(
            text:
                'A very long affirmation that keeps going and going '
                'so that the text has to shrink to fit the image',
            category: 'self_love',
            wordmark: 'Mochi Moon',
            categoryLabel: 'Self-love',
            handle: '@mochimoon',
          ),
        ),
      );
      final image = (await tester.runAsync(() => _decode(png)))!;

      // The overlay entry leaves the tree on the next frame.
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(image.width, 1080);
      expect(find.byType(ShareCardImage), findsNothing);
    });
  });

  group('shareQuote', () {
    testWidgets('hands the rendered image to the share sheet', (tester) async {
      final sharer = FakeImageSharer();
      await tester.pumpWidget(
        _host(sharer, (c, ref) => shareQuote(c, ref, _quote)),
      );

      await tester.tap(find.text('go'));
      await tester.runAsync(() async {
        await tester.pump();
        // Let the image encode and the fake receive it.
        for (var i = 0; i < 50 && sharer.shared.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await tester.pump();
        }
      });

      expect(sharer.shared, hasLength(1));
      expect(sharer.shared.single.fileName, 'mochi_moon_q1.png');
      // PNG signature.
      expect(sharer.shared.single.png.take(4), [0x89, 0x50, 0x4E, 0x47]);
    });

    testWidgets('shows a snack bar when sharing fails', (tester) async {
      final sharer = FakeImageSharer(error: Exception('no share sheet'));
      await tester.pumpWidget(
        _host(sharer, (c, ref) => shareQuote(c, ref, _quote)),
      );

      await tester.tap(find.text('go'));
      await tester.runAsync(() async {
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await tester.pump();
      });
      await tester.pump();

      expect(
        find.text("Couldn't open the share sheet. Please try again."),
        findsOneWidget,
      );
    });

    testWidgets('renders Burmese text without errors', (tester) async {
      final sharer = FakeImageSharer();
      await tester.pumpWidget(
        _host(
          sharer,
          (c, ref) => shareQuote(c, ref, _quote),
          locale: const Locale('my'),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.runAsync(() async {
        await tester.pump();
        for (var i = 0; i < 50 && sharer.shared.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await tester.pump();
        }
      });

      expect(tester.takeException(), isNull);
      expect(sharer.shared, hasLength(1));
    });
  });

  testWidgets('ShareCardImage fits long text and omits a missing handle', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Material(
          child: ShareCardImage(
            text: 'Soft moon',
            category: 'calm',
            wordmark: 'Mochi Moon',
            categoryLabel: 'Calm',
          ),
        ),
      ),
    );

    expect(find.text('Mochi Moon'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
  });
}
