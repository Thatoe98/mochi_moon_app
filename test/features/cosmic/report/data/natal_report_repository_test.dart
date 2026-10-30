import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/errors/app_failure.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/network/readings_api.dart';
import 'package:mochi_moon/core/storage/app_database.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/cosmic/report/data/api_natal_report_repository.dart';
import 'package:mochi_moon/features/cosmic/report/data/drift_natal_report_cache.dart';
import 'package:mochi_moon/features/cosmic/report/data/natal_report_codec.dart';
import 'package:mochi_moon/features/cosmic/report/domain/natal_report.dart';

import '../../../../core/network/fake_http_adapter.dart';

NatalChart _chart({int? minutes = 8 * 60 + 30, int day = 8}) =>
    computeNatalChart(
      BirthData(
        birthDate: DateTime(1998, 11, day),
        birthMinutes: minutes,
        tzId: 'Asia/Bangkok',
        latitude: 13.75,
        longitude: 100.5,
      ),
    );

Map<String, Object?> _report({
  required String status,
  int parts = 0,
  int total = 3,
  String lang = 'en',
}) => {
  'reportId': 'a' * 32,
  'lang': lang,
  'version': 1,
  'status': status,
  'total': total,
  'sections': [
    for (var i = 0; i < parts; i++)
      {'key': 'overview', 'title': 'Part $i', 'body': 'Body $i.'},
  ],
};

void main() {
  group('natalReportRequest', () {
    test('holds placements only, never a birth date, time or place', () {
      final request = natalReportRequest(_chart(), 'en');
      final text = jsonEncode(request);

      expect(text, isNot(contains('1998')));
      expect(text, isNot(contains('Bangkok')));
      expect(text, isNot(contains('13.75')));
      expect(request.keys, {
        'lang',
        'timeKnown',
        'placements',
        'ascendant',
        'midheaven',
        'aspects',
      });
    });

    test('gives houses and angles only when the birth time is known', () {
      final known = natalReportRequest(_chart(), 'en');
      final unknown = natalReportRequest(_chart(minutes: null), 'en');

      expect(known['timeKnown'], isTrue);
      expect(
        (known['placements']! as List).every(
          (p) => (p as Map<String, Object?>)['house'] != null,
        ),
        isTrue,
      );
      expect(unknown['timeKnown'], isFalse);
      expect(unknown.containsKey('ascendant'), isFalse);
      expect(unknown.containsKey('midheaven'), isFalse);
      expect(
        (unknown['placements']! as List).every(
          (p) => (p as Map<String, Object?>)['house'] == null,
        ),
        isTrue,
      );
    });

    test('keeps every degree below 30 and gives the same JSON each time', () {
      final request = natalReportRequest(_chart(), 'my');
      for (final p in request['placements']! as List) {
        final degree = (p as Map<String, Object?>)['degree']! as double;
        expect(degree, inInclusiveRange(0, 29.99));
      }
      expect(request['placements'], hasLength(10));
      expect(
        natalReportKey(natalReportRequest(_chart(), 'my')),
        natalReportKey(request),
      );
      expect(
        natalReportKey(natalReportRequest(_chart(day: 9), 'my')),
        isNot(natalReportKey(request)),
      );
    });
  });

  group('natalReportFromJson', () {
    test('reads a report and round-trips through the saved shape', () {
      final report = natalReportFromJson(_report(status: 'ready', parts: 3));

      expect(report.isReady, isTrue);
      expect(report.sections, hasLength(3));
      expect(report.readMinutes, 2);
      expect(natalReportFromJson(natalReportToJson(report)), report);
    });

    test('throws on a missing field, a bad status or an empty body', () {
      expect(
        () => natalReportFromJson({..._report(status: 'ready'), 'total': null}),
        throwsFormatException,
      );
      expect(
        () => natalReportFromJson(_report(status: 'weird')),
        throwsFormatException,
      );
      expect(
        () => natalReportFromJson({
          ..._report(status: 'ready'),
          'sections': [
            {'key': 'overview', 'title': 'T', 'body': ' '},
          ],
        }),
        throwsFormatException,
      );
    });
  });

  group('ApiNatalReportRepository', () {
    late AppDatabase db;
    late FakeHttpAdapter adapter;
    late ApiNatalReportRepository repository;
    late List<Duration> waits;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      waits = [];
      adapter = FakeHttpAdapter(
        (_) async => jsonResponse(_report(status: 'ready', parts: 3)),
      );
      final dio = createReadingsDio(
        'https://api.example.com/v1',
        () async => 't',
      )..httpClientAdapter = adapter;
      repository = ApiNatalReportRepository(
        api: ReadingsApi(dio),
        cache: DriftNatalReportCache(db),
        wait: (d) async => waits.add(d),
      );
    });
    tearDown(() => db.close());

    Future<List<NatalReport>> read({NatalChart? chart, String lang = 'en'}) =>
        repository.report(chart: chart ?? _chart(), lang: lang).toList();

    test(
      'posts the placements, then polls until the report is ready',
      () async {
        var polls = 0;
        adapter.handler = (options) async {
          if (options.method == 'POST') {
            return jsonResponse(_report(status: 'generating'), status: 202);
          }
          polls++;
          return jsonResponse(
            polls < 2
                ? _report(status: 'generating', parts: 1)
                : _report(status: 'ready', parts: 3),
          );
        };

        final seen = await read();

        expect(seen.map((r) => r.sections.length), [0, 1, 3]);
        expect(seen.last.isReady, isTrue);
        expect(adapter.requests.first.method, 'POST');
        expect(adapter.requests.first.path, 'reports/natal');
        expect(adapter.requests.last.path, 'reports/natal/${'a' * 32}');
        expect(waits, hasLength(2));
      },
    );

    test('a ready report is saved and then needs no network', () async {
      await read();
      adapter.requests.clear();
      adapter.handler = (options) async => throw DioException.connectionError(
        requestOptions: options,
        reason: 'x',
      );

      final again = await read();

      expect(again, hasLength(1));
      expect(again.single.isReady, isTrue);
      expect(adapter.requests, isEmpty);
    });

    test('a changed chart or language asks for a new report', () async {
      await read();
      adapter.requests.clear();

      await read(chart: _chart(day: 9));
      await read(lang: 'my');

      expect(adapter.requests.map((r) => r.method), ['POST', 'POST']);
    });

    test('a failed report is shown and not saved', () async {
      adapter.handler = (_) async =>
          jsonResponse(_report(status: 'failed', parts: 2), status: 202);

      final seen = await read();

      expect(seen.single.isFailed, isTrue);
      expect(
        await DriftNatalReportCache(db).find(
          lang: 'en',
          key: natalReportKey(natalReportRequest(_chart(), 'en')),
        ),
        isNull,
      );
    });

    test('survives a few failed polls but not many', () async {
      var polls = 0;
      adapter.handler = (options) async {
        if (options.method == 'POST') {
          return jsonResponse(_report(status: 'generating'), status: 202);
        }
        polls++;
        if (polls <= 2) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'x',
          );
        }
        return jsonResponse(_report(status: 'ready', parts: 3));
      };
      expect((await read()).last.isReady, isTrue);

      adapter.handler = (options) async {
        if (options.method == 'POST') {
          return jsonResponse(_report(status: 'generating'), status: 202);
        }
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'x',
        );
      };
      await expectLater(
        read(chart: _chart(day: 9)),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('passes on a 429 and a bad shape as errors', () async {
      adapter.handler = (_) async => errorResponse(429, 'rate_limited');
      await expectLater(
        read(),
        throwsA(
          isA<ReadingsApiException>().having((e) => e.status, 'status', 429),
        ),
      );

      adapter.handler = (_) async => jsonResponse({'status': 'ready'});
      await expectLater(read(), throwsFormatException);
    });
  });
}
