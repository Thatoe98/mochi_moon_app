import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_art.dart';

Widget _host(ZodiacSign sign, {Locale? locale, double width = 400}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: ZodiacArt(sign: sign),
          ),
        ),
      ),
    );

void main() {
  test('every sign has its art bundled', () {
    for (final sign in ZodiacSign.values) {
      expect(
        File(zodiacIllustrationAsset(sign)).existsSync(),
        isTrue,
        reason: sign.name,
      );
    }
  });

  testWidgets('describes the picture with the sign name', (tester) async {
    await tester.pumpWidget(_host(ZodiacSign.leo));
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      image.semanticLabel,
      'Mochi the moon bunny in a Leo costume under a glowing Leo constellation',
    );
  });

  testWidgets('describes the picture in Burmese', (tester) async {
    await tester.pumpWidget(_host(ZodiacSign.leo, locale: const Locale('my')));
    await tester.pump();

    final label = tester.widget<Image>(find.byType(Image)).semanticLabel;
    expect(label, contains(RegExp('[က-႟]')));
    expect(label, isNot(contains('{sign}')));
  });

  testWidgets('keeps the portrait shape at half the width', (tester) async {
    await tester.pumpWidget(_host(ZodiacSign.pisces));
    await tester.pump();

    final size = tester.getSize(find.byType(ClipRRect).first);
    expect(size.width, 200);
    expect(size.height, closeTo(200 * 1200 / 896, 0.01));
  });
}
