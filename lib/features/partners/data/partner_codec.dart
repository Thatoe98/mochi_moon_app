import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';

/// Converts a [Partner] to and from the Firestore shape
/// (`users/{uid}/partners/{id}`, PRD §8.1). The id is the document id, so it
/// is not part of the map. `createdAt` is written as an ISO string here and
/// swapped for a `Timestamp` by the Firestore remote.
Map<String, Object?> partnerToMap(Partner partner) => {
  'nickname': partner.nickname,
  'birthDate': formatDate(partner.birthDate),
  'birthTime': partner.birthMinutes == null
      ? null
      : formatMinutes(partner.birthMinutes!),
  'timeKnown': partner.timeKnown,
  'place': partner.birthPlace == null
      ? null
      : birthPlaceToMap(partner.birthPlace!),
  'createdAt': partner.createdAt.toUtc().toIso8601String(),
};

/// Reads what [partnerToMap] wrote (or the Firestore document with a
/// Firestore `Timestamp` for `createdAt`). Returns null when the nickname, birth date
/// or creation date is missing or malformed, so one bad document cannot break
/// the list.
Partner? partnerFromMap(String id, Map<String, Object?> map) {
  final nickname = map['nickname'];
  if (nickname is! String || nickname.trim().isEmpty) return null;
  final birthDate = switch (map['birthDate']) {
    final String text => parseDate(text),
    _ => null,
  };
  final createdAt = switch (map['createdAt']) {
    final Timestamp stamp => stamp.toDate(),
    final String text => DateTime.tryParse(text)?.toLocal(),
    _ => null,
  };
  if (birthDate == null || createdAt == null) return null;
  return Partner(
    id: id,
    nickname: nickname,
    birthDate: birthDate,
    birthMinutes: switch (map['birthTime']) {
      final String text => parseMinutes(text),
      _ => null,
    },
    birthPlace: switch (map['place']) {
      final Map<Object?, Object?> place => birthPlaceFromMap(place),
      _ => null,
    },
    createdAt: createdAt,
  );
}
