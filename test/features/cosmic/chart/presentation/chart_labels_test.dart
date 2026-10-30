import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_glyphs.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';

void main() {
  group('formatDegrees', () {
    test('writes degrees and zero-padded minutes', () {
      expect(formatDegrees(12.5666), '12°33′');
      expect(formatDegrees(0), '0°00′');
      expect(formatDegrees(5.06), '5°03′');
    });

    test('never rounds up into the next degree', () {
      expect(formatDegrees(29.9999), '29°59′');
    });
  });

  group('glyphs', () {
    test('every body has its own glyph', () {
      final glyphs = Body.values.map(bodyGlyph).toSet();
      expect(glyphs.length, Body.values.length);
    });

    test('the sign glyphs run from Aries to Pisces', () {
      expect(signGlyph(ZodiacSign.aries), '♈');
      expect(signGlyph(ZodiacSign.pisces), '♓');
    });
  });

  group('labels and texts', () {
    for (final locale in AppLocalizations.supportedLocales) {
      test(
        'every body and Big 3 text is filled in for ${locale.languageCode}',
        () async {
          final l10n = await AppLocalizations.delegate.load(locale);
          for (final body in Body.values) {
            expect(bodyLabel(l10n, body), isNotEmpty);
          }
          final texts = <String>{};
          for (final role in BigThreeRole.values) {
            expect(bigThreeRoleLabel(l10n, role), isNotEmpty);
            for (final sign in ZodiacSign.values) {
              final text = bigThreeText(l10n, role, sign);
              expect(text, isNotEmpty, reason: '$role $sign');
              texts.add(text);
            }
          }
          // 3 roles × 12 signs, none shared.
          expect(texts.length, BigThreeRole.values.length * 12);
        },
      );
    }

    test('English names', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(bodyLabel(l10n, Body.pluto), 'Pluto');
      expect(bigThreeRoleLabel(l10n, BigThreeRole.rising), 'Rising');
    });
  });
}
