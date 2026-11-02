import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';

/// The Premium note written for her chart and one day's sky (PRD §6.7).
class PersonalNote {
  const PersonalNote({
    required this.date,
    required this.lang,
    required this.version,
    required this.title,
    required this.body,
  });

  /// The local day as `yyyy-MM-dd`.
  final String date;
  final String lang;
  final int version;
  final String title;
  final String body;
}

/// Where the personal note comes from.
abstract interface class PersonalNoteRepository {
  /// The note saved on the device for [date], or null.
  Future<PersonalNote?> cached({required DateTime date, required String lang});

  /// The note for [chart] on [date]: the saved one, otherwise the server's.
  /// Throws the server's error (a 402 for a free user).
  Future<PersonalNote> note({
    required NatalChart chart,
    required DateTime date,
    required String lang,
  });
}
