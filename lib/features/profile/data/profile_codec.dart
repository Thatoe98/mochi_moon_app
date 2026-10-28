import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// Converts a [UserProfile] to and from the shape used in Firestore
/// (`users/{uid}`, PRD §8.1). The local copy stores the same shape as JSON, so
/// there is a single format to keep in step.

Map<String, Object?> profileToMap(UserProfile profile) => {
  'displayName': profile.displayName,
  'profile': {
    'birthDate': profile.birthDate == null
        ? null
        : formatDate(profile.birthDate!),
    'birthTime': profile.birthMinutes == null
        ? null
        : formatMinutes(profile.birthMinutes!),
    'timeKnown': profile.timeKnown,
    'focusAreas': [for (final area in profile.focusAreas) area.id],
  },
};

/// Reads what [profileToMap] wrote. Fields that are missing or malformed come
/// back empty rather than failing, so one bad value cannot lock the user out.
UserProfile profileFromMap(Map<String, Object?> map) {
  final profile = switch (map['profile']) {
    final Map<Object?, Object?> inner => inner,
    _ => const <Object?, Object?>{},
  };
  final focus = profile['focusAreas'];
  return UserProfile(
    displayName: switch (map['displayName']) {
      final String name => name,
      _ => '',
    },
    birthDate: switch (profile['birthDate']) {
      final String text => parseDate(text),
      _ => null,
    },
    birthMinutes: switch (profile['birthTime']) {
      final String text => parseMinutes(text),
      _ => null,
    },
    focusAreas: [
      if (focus is List<Object?>)
        for (final id in focus)
          if (id is String && FocusArea.fromId(id) != null)
            FocusArea.fromId(id)!,
    ],
  );
}

/// `YYYY-MM-DD`.
String formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

DateTime? parseDate(String text) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
  if (match == null) return null;
  final year = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final day = int.parse(match[3]!);
  final date = DateTime(year, month, day);
  // DateTime rolls 02-30 over to March; reject it instead.
  return date.month == month && date.day == day ? date : null;
}

/// `HH:mm` for minutes since midnight.
String formatMinutes(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

int? parseMinutes(String text) {
  final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(text);
  if (match == null) return null;
  final hour = int.parse(match[1]!);
  final minute = int.parse(match[2]!);
  return hour < 24 && minute < 60 ? hour * 60 + minute : null;
}
