import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tz;
import 'package:mochi_moon/features/places/domain/time_zone_resolver.dart';

class LatLngTimeZoneResolver implements TimeZoneResolver {
  const LatLngTimeZoneResolver();

  @override
  String resolve({required double lat, required double lng}) =>
      tz.latLngToTimezoneString(lat, lng);
}
