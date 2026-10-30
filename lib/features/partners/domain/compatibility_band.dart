/// How warm the one-line summary under the meter is (PRD §6.12). Three bands
/// keep the wording gentle: no band says the relationship will fail or
/// succeed.
enum CompatibilityBand {
  low,
  mid,
  high;

  /// The highest overall score still in [low].
  static const lowMax = 54;

  /// The highest overall score still in [mid].
  static const midMax = 74;

  static CompatibilityBand of(int overall) {
    if (overall <= lowMax) return low;
    if (overall <= midMax) return mid;
    return high;
  }
}
