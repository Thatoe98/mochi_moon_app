import 'package:freezed_annotation/freezed_annotation.dart';

part 'birth_place.freezed.dart';

/// Where the user was born, as stored in the profile (PRD §8.1).
///
/// [tzId] is the IANA zone looked up when the place was picked; the birth time
/// is read in that zone.
@freezed
abstract class BirthPlace with _$BirthPlace {
  const factory BirthPlace({
    required String name,
    required String region,
    required String countryCode,
    required double lat,
    required double lng,
    required String tzId,
  }) = _BirthPlace;
}
