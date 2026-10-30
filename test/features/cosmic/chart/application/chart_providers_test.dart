import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/chart/application/chart_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../../auth/support/fake_auth_repository.dart';
import '../../../profile/support/fake_profile.dart';

const _bangkok = BirthPlace(
  name: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  lat: 13.75,
  lng: 100.5,
  tzId: 'Asia/Bangkok',
);

ProviderContainer _container(UserProfile? profile) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(profile),
      ),
      profileRemoteProvider.overrideWithValue(null),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Reads an auto-disposed provider's next settled value, keeping it alive
/// while it loads.
Future<T> _load<T>(
  ProviderContainer container,
  ProviderListenable<AsyncValue<T>> provider,
) {
  final done = Completer<T>();
  final subscription = container.listen<AsyncValue<T>>(provider, (_, next) {
    if (done.isCompleted) return;
    switch (next) {
      case AsyncData(:final value):
        done.complete(value);
      case AsyncError(:final error, :final stackTrace):
        done.completeError(error, stackTrace);
      case AsyncLoading():
        break;
    }
  }, fireImmediately: true);
  return done.future.whenComplete(subscription.close);
}

void main() {
  test('is null while there is no birth date', () async {
    final container = _container(null);
    expect(await _load(container, natalChartProvider), isNull);
  });

  test('casts the chart from the profile', () async {
    final container = _container(
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 11, 8),
        birthMinutes: 8 * 60 + 30,
        birthPlace: _bangkok,
      ),
    );
    final chart = (await _load(container, natalChartProvider))!;
    expect(chart.timeKnown, isTrue);
    expect(chart.placementOf(Body.sun).sign, ZodiacSign.scorpio);
    expect(chart.placementOf(Body.moon).sign, ZodiacSign.cancer);
    expect(chart.ascendantSign, ZodiacSign.sagittarius);
  });

  test('has no Ascendant or houses without a birth time', () async {
    final container = _container(
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 11, 8),
        birthPlace: _bangkok,
      ),
    );
    final chart = (await _load(container, natalChartProvider))!;
    expect(chart.timeKnown, isFalse);
    expect(chart.ascendant, isNull);
    expect(chart.houseOf(Body.sun), isNull);
    expect(chart.moonIsApproximate, isTrue);
  });

  test('works without a birthplace', () async {
    final container = _container(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 11, 8)),
    );
    final chart = (await _load(container, natalChartProvider))!;
    expect(chart.placementOf(Body.sun).sign, ZodiacSign.scorpio);
  });

  test('is cast again when the profile changes', () async {
    final container = _container(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 11, 8)),
    );
    final first = (await _load(container, natalChartProvider))!;
    expect(first.placementOf(Body.sun).sign, ZodiacSign.scorpio);

    await container
        .read(profileControllerProvider.notifier)
        .save(
          UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 3, 28)),
        );
    final second = (await _load(container, natalChartProvider))!;
    expect(second.placementOf(Body.sun).sign, ZodiacSign.aries);
  });
}
