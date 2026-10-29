import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/retrogrades.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// Horizons gives hourly samples and the engine bisects to an hour, so
/// stations should agree to a few hours.
const _stationTolerance = Duration(hours: 3);

/// Shadow edges are interpolated, and the planet is moving slowly there.
const _shadowTolerance = Duration(hours: 8);

typedef _Golden = ({
  Body body,
  DateTime preShadowStart,
  DateTime retrogradeStart,
  DateTime retrogradeEnd,
  DateTime postShadowEnd,
});

List<_Golden> _loadGolden() {
  final file = File('test/features/cosmic/astro/golden_events.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return [
    for (final entry in json['retrogrades'] as List<dynamic>)
      (
        body: Body.values.byName((entry as Map<String, dynamic>)['body'] as String),
        preShadowStart: DateTime.parse(entry['preShadowStart'] as String),
        retrogradeStart: DateTime.parse(entry['retrogradeStart'] as String),
        retrogradeEnd: DateTime.parse(entry['retrogradeEnd'] as String),
        postShadowEnd: DateTime.parse(entry['postShadowEnd'] as String),
      ),
  ];
}

Duration _gap(DateTime a, DateTime b) => a.difference(b).abs();

void main() {
  final golden = _loadGolden();

  for (final year in [2026, 2027]) {
    group('retrogrades($year)', () {
      final calendar = retrogrades(year);
      final yearStart = DateTime.utc(year);
      final yearEnd = DateTime.utc(year + 1);
      final expected = [
        for (final g in golden)
          if (g.postShadowEnd.isAfter(yearStart) &&
              g.preShadowStart.isBefore(yearEnd))
            g,
      ];

      test('has the periods Horizons has, no more and no fewer', () {
        for (final body in [
          Body.mercury,
          Body.venus,
          Body.mars,
          Body.jupiter,
          Body.saturn,
        ]) {
          expect(
            calendar.forBody(body).length,
            expected.where((g) => g.body == body).length,
            reason: body.name,
          );
        }
        expect(calendar.periods.length, expected.length);
      });

      test('stations and shadows match Horizons', () {
        for (final body in Body.values) {
          final ours = calendar.forBody(body);
          final theirs = expected.where((g) => g.body == body).toList();
          for (var i = 0; i < theirs.length; i++) {
            final reason = '${body.name} #$i';
            expect(
              _gap(ours[i].retrogradeStart, theirs[i].retrogradeStart),
              lessThan(_stationTolerance),
              reason: '$reason retrograde station: ${ours[i].retrogradeStart}',
            );
            expect(
              _gap(ours[i].retrogradeEnd, theirs[i].retrogradeEnd),
              lessThan(_stationTolerance),
              reason: '$reason direct station: ${ours[i].retrogradeEnd}',
            );
            expect(
              _gap(ours[i].preShadowStart, theirs[i].preShadowStart),
              lessThan(_shadowTolerance),
              reason: '$reason pre-shadow: ${ours[i].preShadowStart}',
            );
            expect(
              _gap(ours[i].postShadowEnd, theirs[i].postShadowEnd),
              lessThan(_shadowTolerance),
              reason: '$reason post-shadow: ${ours[i].postShadowEnd}',
            );
          }
        }
      });

      test('periods are ordered and well formed', () {
        for (var i = 1; i < calendar.periods.length; i++) {
          expect(
            calendar.periods[i].preShadowStart.isBefore(
              calendar.periods[i - 1].preShadowStart,
            ),
            isFalse,
          );
        }
        for (final p in calendar.periods) {
          expect(p.preShadowStart.isBefore(p.retrogradeStart), isTrue);
          expect(p.retrogradeStart.isBefore(p.retrogradeEnd), isTrue);
          expect(p.retrogradeEnd.isBefore(p.postShadowEnd), isTrue);
          // Retrograde carries the planet back, so it turns direct at a lower
          // longitude than it turned retrograde at.
          expect(
            signedAngleDifference(
              p.retrogradeStartLongitude,
              p.retrogradeEndLongitude,
            ),
            greaterThan(0),
          );
        }
      });

      test('retrograde spans agree with the speed of the planet', () {
        for (final p in calendar.periods) {
          final middle = p.retrogradeStart.add(
            p.retrogradeEnd.difference(p.retrogradeStart) ~/ 2,
          );
          expect(p.isRetrogradeAt(middle), isTrue);
          expect(speedAt(p.body, middle), lessThan(0), reason: '$p.body');
          final before = p.retrogradeStart.subtract(const Duration(days: 2));
          final after = p.retrogradeEnd.add(const Duration(days: 2));
          expect(p.isRetrogradeAt(before), isFalse);
          expect(speedAt(p.body, before), greaterThanOrEqualTo(0));
          expect(p.isRetrogradeAt(after), isFalse);
          expect(speedAt(p.body, after), greaterThanOrEqualTo(0));
        }
      });
    });
  }

  group('published Mercury retrogrades (PRD §9.5)', () {
    // Oct 24 - Nov 13 2026, Feb 9 - Mar 3 2027, Jun 10 - Jul 4 2027,
    // each to within one day.
    final published = [
      (DateTime.utc(2026, 10, 24), DateTime.utc(2026, 11, 13)),
      (DateTime.utc(2027, 2, 9), DateTime.utc(2027, 3, 3)),
      (DateTime.utc(2027, 6, 10), DateTime.utc(2027, 7, 4)),
    ];

    test('are found', () {
      final found = [
        ...retrogrades(2026).forBody(Body.mercury),
        ...retrogrades(2027).forBody(Body.mercury),
      ];
      for (final (start, end) in published) {
        final match = found.where(
          (p) => _gap(p.retrogradeStart, start) < const Duration(days: 1),
        );
        expect(match, hasLength(greaterThanOrEqualTo(1)), reason: '$start');
        expect(
          _gap(match.first.retrogradeEnd, end),
          lessThan(const Duration(days: 1)),
          reason: '$end',
        );
      }
    });
  });

  test('a period that spans two years appears in both calendars', () {
    // Saturn's retrograde starts in July 2026; its shadow runs into 2027.
    final saturn2026 = retrogrades(2026)
        .forBody(Body.saturn)
        .singleWhere((p) => p.retrogradeStart.year == 2026);
    final saturn2027 = retrogrades(2027).forBody(Body.saturn);
    expect(
      saturn2027.map((p) => p.retrogradeStart),
      contains(saturn2026.retrogradeStart),
    );
  });
}
