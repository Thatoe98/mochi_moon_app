import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';
import 'package:mochi_moon/features/cosmic/moon/presentation/moon_labels.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    test('every phase has its own name and affirmation in $locale', () async {
      final l10n = await AppLocalizations.delegate.load(locale);
      final names = {
        for (final phase in MoonPhaseName.values) moonPhaseLabel(l10n, phase),
      };
      final affirmations = {
        for (final phase in MoonPhaseName.values) moonAffirmation(l10n, phase),
      };

      expect(names, hasLength(MoonPhaseName.values.length));
      expect(affirmations, hasLength(MoonPhaseName.values.length));
      expect([...names, ...affirmations], everyElement(isNotEmpty));
    });
  }

  test('the new moon is about intentions, the full moon about thanks', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(moonAffirmation(l10n, MoonPhaseName.newMoon), contains('intention'));
    expect(moonAffirmation(l10n, MoonPhaseName.fullMoon), contains('grateful'));
  });
}
