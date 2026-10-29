import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';

/// The bundled art of [sign]: Mochi in that sign's outfit (PRD §8.4).
String zodiacIllustrationAsset(ZodiacSign sign) =>
    'assets/illustrations/ill_zodiac_${sign.name}.webp';

/// Mochi dressed as [sign], sized to a share of the available width so it
/// scales with the screen and never towers over the text below it.
class ZodiacArt extends StatelessWidget {
  const ZodiacArt({required this.sign, this.widthFactor = 0.5, super.key});

  final ZodiacSign sign;
  final double widthFactor;

  /// The art is portrait, 896 x 1200.
  static const double _aspectRatio = 896 / 1200;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: MochiIllustration(
              asset: zodiacIllustrationAsset(sign),
              semanticLabel: l10n.illustrationZodiac(
                zodiacSignLabel(l10n, sign),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
