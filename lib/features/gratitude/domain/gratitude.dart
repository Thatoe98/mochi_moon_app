import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

/// At most this many entries a local day (PRD §6.16).
const gratitudePerDay = 3;

/// At most this many characters an entry (PRD §6.16, matched by the rules).
const gratitudeMaxLength = 200;

/// One grateful thought or small win she wrote down. It is private writing:
/// it never goes to the AI API or to analytics.
@immutable
class GratitudeNote {
  /// [day] is cut to its local date.
  GratitudeNote({
    required this.id,
    required DateTime day,
    required this.body,
    required this.createdAt,
  }) : day = DateTime(day.year, day.month, day.day);

  final String id;
  final DateTime day;
  final String body;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      other is GratitudeNote &&
      other.id == id &&
      other.day == day &&
      other.body == body &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, day, body, createdAt);
}

/// Why an entry was not added.
enum GratitudeRejection { empty, tooLong, dayFull }

/// A new random id, like a Firestore auto id.
String newGratitudeId([Random? random]) {
  final rng = random ?? Random.secure();
  const alphabet =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes([
    for (var i = 0; i < 20; i++)
      alphabet.codeUnitAt(rng.nextInt(alphabet.length)),
  ]);
}

/// Checks [text] against the rules of PRD §6.16: it must not be empty after
/// trimming, at most [gratitudeMaxLength] characters, and [countToday] must be
/// below [gratitudePerDay]. Null means it can be added.
GratitudeRejection? checkGratitude(String text, {required int countToday}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return GratitudeRejection.empty;
  if (trimmed.runes.length > gratitudeMaxLength) {
    return GratitudeRejection.tooLong;
  }
  if (countToday >= gratitudePerDay) return GratitudeRejection.dayFull;
  return null;
}

/// How many entries were written on the local day of [today].
int gratitudeCountOn(Iterable<GratitudeNote> entries, DateTime today) {
  final day = DateTime(today.year, today.month, today.day);
  return entries.where((entry) => entry.day == day).length;
}

/// The entries from days before [today], in random order. Today's entries are
/// left out, so opening the jar never starts with what she just wrote.
List<GratitudeNote> shuffledPast(
  Iterable<GratitudeNote> entries,
  DateTime today, [
  Random? random,
]) {
  final day = DateTime(today.year, today.month, today.day);
  return [
    for (final entry in entries)
      if (entry.day.isBefore(day)) entry,
  ]..shuffle(random);
}

/// `YYYY-MM-DD` for the local date of [day].
String gratitudeDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// The date a [gratitudeDateKey] stands for, or null when [key] is not one.
DateTime? parseGratitudeDateKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  final date = DateTime(year, month, day);
  return date.month == month && date.day == day ? date : null;
}
