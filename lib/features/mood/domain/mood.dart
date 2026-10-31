import 'package:freezed_annotation/freezed_annotation.dart';

/// How she feels today (PRD §6.18). [id] is what is stored on the device and
/// in Firestore, so it must never change.
enum Mood {
  happy('happy'),
  calm('calm'),
  tired('tired'),
  sad('sad'),
  anxious('anxious'),
  inLove('in_love');

  // Enum constructors must stay const for the analyzer and the lint disagrees.
  // ignore: unnecessary_const_in_enum_constructor
  const Mood(this.id);

  final String id;

  /// The mood stored as [id], or null for an id this version does not know.
  static Mood? fromId(String id) {
    for (final mood in values) {
      if (mood.id == id) return mood;
    }
    return null;
  }
}

/// The mood chosen for one local day.
@immutable
class DayMood {
  /// [day] is cut to its local date.
  DayMood({required DateTime day, required this.mood})
    : day = DateTime(day.year, day.month, day.day);

  final DateTime day;
  final Mood mood;

  @override
  bool operator ==(Object other) =>
      other is DayMood && other.day == day && other.mood == mood;

  @override
  int get hashCode => Object.hash(day, mood);
}

/// `YYYY-MM-DD` for the local date of [day]; the key of a day's mood.
String moodDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// The date a [moodDateKey] stands for, or null when [key] is not one.
DateTime? parseMoodDateKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  final date = DateTime(year, month, day);
  return date.month == month && date.day == day ? date : null;
}
