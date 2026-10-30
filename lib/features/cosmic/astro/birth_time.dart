import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Minutes after midnight that stand in for an unknown birth time (PRD §9.1).
const int unknownBirthTimeMinutes = 12 * 60;

/// The zone used to read a birth date when no birthplace was given. UTC can
/// put a birth within half a day of a sign change in the neighbouring sign.
const String noPlaceTimeZone = 'UTC';

bool _timeZonesReady = false;

/// The moment of birth as a UTC instant (PRD §9.1).
///
/// [birthDate] is a calendar date (its time part is ignored) and
/// [birthMinutes] is minutes since midnight on the clock at the birthplace.
/// A null [birthMinutes] means the time is unknown, so noon local time is
/// used. [tzId] is an IANA zone such as `Asia/Bangkok`; historical offsets and
/// daylight saving come from the `timezone` database. A clock time that was
/// skipped or repeated by a daylight saving change is resolved the way the
/// `timezone` package resolves it.
///
/// Throws [tz.LocationNotFoundException] when [tzId] is not a known zone.
DateTime birthInstantUtc({
  required DateTime birthDate,
  required String tzId,
  int? birthMinutes,
}) {
  _ensureTimeZones();
  final minutes = birthMinutes ?? unknownBirthTimeMinutes;
  return tz.TZDateTime(
    tz.getLocation(tzId),
    birthDate.year,
    birthDate.month,
    birthDate.day,
    minutes ~/ 60,
    minutes % 60,
  ).toUtc();
}

void _ensureTimeZones() {
  if (_timeZonesReady) return;
  tzdata.initializeTimeZones();
  _timeZonesReady = true;
}
