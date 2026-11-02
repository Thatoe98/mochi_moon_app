import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';
import 'package:mochi_moon/features/partners/data/api_compat_report_repository.dart';
import 'package:mochi_moon/features/partners/data/compat_report_codec.dart';

import '../../../core/network/fake_http_adapter.dart';

NatalChart _chart(int day) => computeNatalChart(
  BirthData(
    birthDate: DateTime(1998, 11, day),
    birthMinutes: 8 * 60 + 30,
    tzId: 'Asia/Bangkok',
    latitude: 13.75,
    longitude: 100.5,
  ),
);

Map<String, Object?> _report({required String status, int parts = 0}) => {
  'reportId': 'b' * 32,
  'lang': 'en',
  'version': 1,
  'status': status,
  'total': 5,
  'sections': [
    for (var i = 0; i < parts; i++)
      {'key': 'overview', 'title': 'Part $i', 'body': 'Body $i.'},
  ],
};

void main() {
  final you = _chart(8);
  final them = _chart(20);
  final score = synastry(you, them);

  Map<String, Object?> request({String id = 'abc123'}) => compatReportRequest(
    partnerId: id,
    you: you,
    them: them,
    synastry: score,
    lang: 'en',
  );

  group('compatReportRequest', () {
    test('holds placements and scores only, no birth data or name', () {
      final body = request();
      final text = jsonEncode(body);

      expect(body.keys, {'lang', 'partnerId', 'a', 'b', 'score', 'topAspects'});
      expect(text, isNot(contains('1998')));
      expect(text, isNot(contains('Bangkok')));
      expect(text, isNot(contains('13.75')));
      expect(body['score'], {
        'overall': score.overall,
        'romance': score.romance,
        'emotional': score.emotional,
        'communication': score.communication,
      });
    });

    test('sends at most 12 planet aspects and keeps degrees below 30', () {
      final aspects = request()['topAspects']! as List;
      expect(aspects.length, lessThanOrEqualTo(12));
      for (final a in aspects) {
        expect((a as Map<String, Object?>).keys, {'a', 'b', 'type', 'orb'});
      }
      for (final side in ['a', 'b']) {
        final block = request()[side]! as Map<String, Object?>;
        for (final p in block['placements']! as List) {
          expect(
            (p as Map<String, Object?>)['degree']! as double,
            lessThan(30),
          );
          expect(p.containsKey('house'), isFalse);
        }
      }
    });

    test('is the same for the same pair and differs for another', () {
      expect(compatReportKey(request()), compatReportKey(request()));
      expect(
        compatReportKey(request()),
        isNot(compatReportKey(request(id: 'other'))),
      );
    });
  });

  group('ApiCompatReportRepository', () {
    late AppDatabase db;
    late FakeHttpAdapter adapter;
    late ApiCompatReportRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      adapter = FakeHttpAdapter(
        (_) async => jsonResponse(_report(status: 'ready', parts: 5)),
      );
      final dio = createReadingsDio(
        'https://api.example.com/v1',
        () async => 't',
      )..httpClientAdapter = adapter;
      repository = ApiCompatReportRepository(
        api: ReadingsApi(dio),
        cache: DriftNatalReportCache(db),
        wait: (_) async {},
      );
    });
    tearDown(() => db.close());

    Future<List<NatalReport>> read({String id = 'abc123'}) => repository
        .report(
          partnerId: id,
          you: you,
          them: them,
          synastry: score,
          lang: 'en',
        )
        .toList();

    test('posts to the compatibility route, polls, then saves', () async {
      var polls = 0;
      adapter.handler = (options) async {
        if (options.method == 'POST') {
          return jsonResponse(_report(status: 'generating'), status: 202);
        }
        polls++;
        return jsonResponse(
          polls < 2
              ? _report(status: 'generating', parts: 2)
              : _report(status: 'ready', parts: 5),
        );
      };

      final seen = await read();

      expect(seen.map((r) => r.sections.length), [0, 2, 5]);
      expect(adapter.requests.first.path, 'reports/compatibility');
      expect(adapter.requests.last.path, 'reports/compatibility/${'b' * 32}');
    });

    test('a ready report is saved per partner and needs no network', () async {
      await read();
      adapter.requests.clear();

      expect(await read(), hasLength(1));
      expect(adapter.requests, isEmpty);

      await read(id: 'other');
      expect(adapter.requests.map((r) => r.method), ['POST']);
    });

    test(
      'does not touch the natal report saved for the same language',
      () async {
        await read();
        expect(
          await DriftNatalReportCache(db).find(lang: 'en', key: 'x'),
          isNull,
        );
      },
    );

    test('a 402 reaches the screen as a Premium-required error', () async {
      adapter.handler = (_) async => jsonResponse({
        'error': {'code': 'premium_required', 'message': 'Premium'},
      }, status: 402);

      await expectLater(
        read(),
        throwsA(
          isA<ReadingsApiException>().having(
            (e) => e.isPremiumRequired,
            'isPremiumRequired',
            isTrue,
          ),
        ),
      );
    });
  });
}
