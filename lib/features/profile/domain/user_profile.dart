import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';

part 'user_profile.freezed.dart';

/// Most focus areas a user can pick (PRD §6.1).
const maxFocusAreas = 3;

/// Longest name the profile accepts.
const maxDisplayNameLength = 40;

/// The earliest birth year the date picker offers (PRD §6.1).
const earliestBirthYear = 1940;

/// What the user wants the app to help with. [id] is the stored value and
/// matches the quote categories, so the For You deck can use it directly.
enum FocusArea {
  selfLove('self_love'),
  confidence('confidence'),
  healing('healing'),
  studyWork('study_work'),
  bodyKindness('body_kindness'),
  calm('calm');

  FocusArea(this.id);

  final String id;

  static FocusArea? fromId(String id) {
    for (final area in values) {
      if (area.id == id) return area;
    }
    return null;
  }
}

/// What the user told us about themselves.
///
/// Only the name is needed to have a profile. The birth data is optional: it is
/// asked for the first time the user opens the Cosmic tab (PRD §6.1), so every
/// astro field here (and the signs derived from it) can be absent.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String displayName,

    /// Date only; the time part is ignored. Null until the user unlocks Cosmic.
    DateTime? birthDate,

    /// Minutes since midnight, local to the birthplace. Null means the user
    /// does not know the birth time.
    int? birthMinutes,

    /// Required in the first-run flow when the birth time is known.
    BirthPlace? birthPlace,
    @Default(<FocusArea>[]) List<FocusArea> focusAreas,
  }) = _UserProfile;

  const UserProfile._();

  /// PRD §6.1: "I don't know" sets `timeKnown = false`.
  bool get timeKnown => birthMinutes != null;

  /// She has an account profile once she has given a name. This is what ends
  /// the first-run profile steps; birth data is not needed for it.
  bool get hasAccountProfile => displayName.trim().isNotEmpty;

  /// Whether the Cosmic features can be computed: a birth date was given. The
  /// birth time and place stay optional.
  bool get hasBirthData => birthDate != null;

  /// Whether this can be saved from the edit form on [today]: a name, and
  /// either no birth data at all or a real birth date with a birthplace
  /// whenever a birth time is given (PRD §6.1).
  bool isValidFor(DateTime today) {
    if (!hasAccountProfile ||
        displayName.trim().length > maxDisplayNameLength) {
      return false;
    }
    final date = birthDate;
    // A birth time or place means nothing without a birth date.
    if (date == null) return birthMinutes == null && birthPlace == null;
    return isValidBirthDate(date, today) &&
        (birthMinutes == null || birthPlace != null);
  }
}

/// True when [date] can be a birth date: from [earliestBirthYear] up to and
/// including [today].
bool isValidBirthDate(DateTime date, DateTime today) {
  final day = DateTime(date.year, date.month, date.day);
  final last = DateTime(today.year, today.month, today.day);
  return date.year >= earliestBirthYear && !day.isAfter(last);
}

/// [areas] with [area] switched on or off, or unchanged when switching on
/// would pass [maxFocusAreas]. Order is the order they were picked in.
List<FocusArea> toggleFocusArea(List<FocusArea> areas, FocusArea area) {
  if (areas.contains(area)) return [...areas]..remove(area);
  if (areas.length >= maxFocusAreas) return areas;
  return [...areas, area];
}
