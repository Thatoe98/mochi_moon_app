import 'package:flutter/material.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Bundled font with just the planet and zodiac glyphs (`assets/fonts`), so
/// they look the same on every phone and never turn into color emoji.
const String symbolsFontFamily = 'Mochi Symbols';

/// The notation for "retrograde", like the degree sign: not translated.
const String retrogradeMark = 'Rx';

/// The astrological glyph of [body].
String bodyGlyph(Body body) => switch (body) {
  Body.sun => '☉',
  Body.moon => '☽',
  Body.mercury => '☿',
  Body.venus => '♀',
  Body.mars => '♂',
  Body.jupiter => '♃',
  Body.saturn => '♄',
  Body.uranus => '♅',
  Body.neptune => '♆',
  Body.pluto => '♇',
};

/// The zodiac glyph of [sign], from Aries (U+2648) to Pisces (U+2653).
String signGlyph(ZodiacSign sign) => String.fromCharCode(0x2648 + sign.index);

/// A glyph in the symbols font. It is decorative: the name written next to it
/// carries the meaning for screen readers.
class Glyph extends StatelessWidget {
  const Glyph(this.symbol, {this.style, super.key});

  final String symbol;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.titleLarge;
    return ExcludeSemantics(
      child: Text(symbol, style: base?.copyWith(fontFamily: symbolsFontFamily)),
    );
  }
}
