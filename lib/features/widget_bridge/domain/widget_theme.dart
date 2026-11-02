/// How the home-screen widget looks (PRD §6.5). The cream theme is free; the
/// others are Premium. [id] is saved and handed to the Android side, so it
/// must never change.
enum WidgetTheme {
  cream('cream', premium: false),
  lavender('lavender', premium: true),
  peach('peach', premium: true),
  midnight('midnight', premium: true);

  WidgetTheme(this.id, {required this.premium});

  final String id;
  final bool premium;

  /// The theme saved as [id], or the free one for an id this version does not
  /// know.
  static WidgetTheme fromId(String? id) => values.firstWhere(
    (theme) => theme.id == id,
    orElse: () => WidgetTheme.cream,
  );

  /// What the widget actually shows: a Premium theme needs Premium, so a
  /// lapsed subscription goes back to cream while her choice is kept.
  WidgetTheme effective({required bool hasPremium}) =>
      premium && !hasPremium ? WidgetTheme.cream : this;
}

/// Her saved widget theme choice.
abstract interface class WidgetThemeRepository {
  Future<WidgetTheme> load();

  Future<void> save(WidgetTheme theme);
}
