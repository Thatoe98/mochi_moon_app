/// Finds the IANA time zone (for example `Asia/Bangkok`) of a spot on Earth.
abstract interface class TimeZoneResolver {
  String resolve({required double lat, required double lng});
}
