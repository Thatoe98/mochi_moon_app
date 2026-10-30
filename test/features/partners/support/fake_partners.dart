import 'dart:async';

import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_repository.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';

/// A partner with sensible defaults, for tests.
Partner partner(
  String id, {
  String nickname = 'Luna',
  DateTime? birthDate,
  int? birthMinutes,
  BirthPlace? birthPlace,
  int day = 1,
}) => Partner(
  id: id,
  nickname: nickname,
  birthDate: birthDate ?? DateTime(1998, 5, 14),
  birthMinutes: birthMinutes,
  birthPlace: birthPlace,
  createdAt: DateTime(2026, 10, day),
);

const bangkok = BirthPlace(
  name: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  lat: 13.75,
  lng: 100.52,
  tzId: 'Asia/Bangkok',
);

/// In-memory [PartnerRepository] for tests.
class FakePartnerRepository implements PartnerRepository {
  FakePartnerRepository([List<Partner> seed = const []]) : saved = [...seed];

  final List<Partner> saved;
  final _changes = StreamController<void>.broadcast();

  List<Partner> get _oldestFirst => [
    ...saved..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
  ];

  @override
  Future<List<Partner>> partners() async => _oldestFirst;

  @override
  Stream<List<Partner>> watch() async* {
    yield _oldestFirst;
    await for (final _ in _changes.stream) {
      yield _oldestFirst;
    }
  }

  @override
  Future<void> save(Partner partner) async {
    saved
      ..removeWhere((p) => p.id == partner.id)
      ..add(partner);
    _changes.add(null);
  }

  @override
  Future<void> remove(String id) async {
    saved.removeWhere((p) => p.id == id);
    _changes.add(null);
  }

  @override
  Future<void> addMissing(List<Partner> partners) async {
    for (final partner in partners) {
      if (saved.every((p) => p.id != partner.id)) saved.add(partner);
    }
    _changes.add(null);
  }
}

/// In-memory [PartnerRemote] for tests, keyed by uid.
class FakePartnerRemote implements PartnerRemote {
  FakePartnerRemote([Map<String, List<Partner>>? stored])
    : stored = stored ?? {};

  final Map<String, List<Partner>> stored;

  /// When set, every call fails with it.
  Exception? error;

  /// How many times [put] succeeded.
  int puts = 0;

  List<String> idsOf(String uid) => [
    for (final partner in stored[uid] ?? const <Partner>[]) partner.id,
  ];

  @override
  Future<List<Partner>> fetch(String uid) async {
    if (error case final error?) throw error;
    return [...?stored[uid]];
  }

  @override
  Future<void> put(String uid, Partner partner) async {
    if (error case final error?) throw error;
    puts++;
    stored.putIfAbsent(uid, () => [])
      ..removeWhere((p) => p.id == partner.id)
      ..add(partner);
  }

  @override
  Future<void> delete(String uid, String id) async {
    if (error case final error?) throw error;
    stored[uid]?.removeWhere((p) => p.id == id);
  }
}
