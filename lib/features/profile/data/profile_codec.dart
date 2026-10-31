import 'package:mochi_moon/features/profile/domain/birth_place.dart';
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
    // Only meaningful with a birth date (PRD §8.1).
    'timeKnown': profile.hasBirthData ? profile.timeKnown : null,
    'place': profile.birthPlace == null
        ? null
        : birthPlaceToMap(profile.birthPlace!),
    'focusAreas': [for (final area in profile.focusAreas) area.id],
  },
};

/// [profileToMap] for a Firestore write that is merged into the existing
/// document. Without birth data the birth fields are left out, so a profile
/// that has none on this device can never blank out birth data the account
/// already holds (clearing it is not offered in the app).
Map<String, Object?> profileToRemoteMap(UserProfile profile) {
  final map = profileToMap(profile);
  if (profile.hasBirthData) return map;
  final inner = Map<String, Object?>.of(map['profile']! as Map<String, Object?>)
    ..removeWhere((key, _) => _birthKeys.contains(key));
  return {...map, 'profile': inner};
}

const _birthKeys = {'birthDate', 'birthTime', 'timeKnown', 'place'};

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
    birthPlace: switch (profile['place']) {
      final Map<Object?, Object?> place => birthPlaceFromMap(place),
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

/// The Firestore shape of a birthplace, shared by the profile and partners.
Map<String, Object?> birthPlaceToMap(BirthPlace place) => {
  'name': place.name,
  'region': place.region,
  'countryCode': place.countryCode,
  'lat': place.lat,
  'lng': place.lng,
  'tzId': place.tzId,
};

/// A place with a missing name, coordinate or zone is dropped as a whole: a
/// half-known place would put the birth time in the wrong zone.
BirthPlace? birthPlaceFromMap(Map<Object?, Object?> map) {
  final name = map['name'];
  final countryCode = map['countryCode'];
  final lat = map['lat'];
  final lng = map['lng'];
  final tzId = map['tzId'];
  if (name is! String || name.isEmpty) return null;
  if (countryCode is! String || tzId is! String || tzId.isEmpty) return null;
  if (lat is! num || lng is! num) return null;
  return BirthPlace(
    name: name,
    region: switch (map['region']) {
      final String region => region,
      _ => '',
    },
    countryCode: countryCode,
    lat: lat.toDouble(),
    lng: lng.toDouble(),
    tzId: tzId,
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
