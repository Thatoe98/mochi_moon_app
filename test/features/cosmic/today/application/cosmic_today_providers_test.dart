import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/asset_content_repository.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/features/cosmic/astro/sun_moon_signs.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

import '../../../../support/disk_bundle.dart';
import '../../../profile/support/fake_profile.dart';
import '../support/fake_thai_colors_setting.dart';

const _bangkok = BirthPlace(
  name: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  lat: 13.75,
  lng: 100.5,
  tzId: 'Asia/Bangkok',
);

ProviderContainer _container({
  UserProfile? profile,
  FakeThaiColorsSettingRepository? thai,
  DateTime? now,
}) {
  final container = ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(profile),
      ),
      contentRepositoryProvider.overrideWithValue(
        AssetContentRepository(bundle: DiskBundle()),
      ),
      thaiColorsSettingRepositoryProvider.overrideWithValue(
        thai ?? FakeThaiColorsSettingRepository(),
      ),
      clockProvider.overrideWithValue(
        () => now ?? DateTime(2026, 10, 29, 12),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Reads an auto-disposed provider's value, keeping it alive while it loads.
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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('userSunSign', () {
    test('is null without a profile', () async {
      final container = _container();
      expect(await _load(container, userSunSignProvider), isNull);
    });

    test('is null while the profile has no birth date', () async {
      final container = _container(
        profile: const UserProfile(displayName: 'Mochi'),
      );
      expect(await _load(container, userSunSignProvider), isNull);
    });

    test('is the Sun sign of the birth date', () async {
      final container = _container(
        profile: UserProfile(
          displayName: 'Mochi',
          birthDate: DateTime(1998, 11, 8),
        ),
      );
      expect(
        await _load(container, userSunSignProvider),
        ZodiacSign.scorpio,
      );
    });

    test('reads the birth time in the zone of the birthplace', () async {
      final birthDate = DateTime(1998, 11, 22);
      final container = _container(
        profile: UserProfile(
          displayName: 'Mochi',
          birthDate: birthDate,
          birthMinutes: 30,
          birthPlace: _bangkok,
        ),
      );
      expect(
        await _load(container, userSunSignProvider),
        sunMoonSigns(
          birthDate: birthDate,
          tzId: 'Asia/Bangkok',
          birthMinutes: 30,
        ).sun,
      );
    });
  });

  group('cosmicToday', () {
    final scorpio = UserProfile(
      displayName: 'Mochi',
      birthDate: DateTime(1998, 11, 8),
    );

    test('is null until there is a birth date', () async {
      final container = _container();
      expect(await _load(container, cosmicTodayProvider('en')), isNull);
    });

    test('puts the sign, text, colors and number together', () async {
      final container = _container(profile: scorpio);
      final today = (await _load(container, cosmicTodayProvider('en')))!;

      expect(today.date, DateTime(2026, 10, 29));
      expect(today.sign, ZodiacSign.scorpio);
      expect(today.reading.headline, 'Your depth is a superpower');
      expect(today.reading.avoid, hasLength(3));
      expect(today.luckyNumber, 8);
      // palette[(302 + 7) % 4] of Scorpio
      expect(today.luckyColors.sign.name, 'Berry');
      expect(today.thaiColors.today.name, 'Orange');
      // 8 November 1998 was a Sunday.
      expect(today.thaiColors.birthday?.name, 'Red');
    });

    test('is the same all day and changes at midnight', () async {
      Future<String> headlineAt(DateTime now) async {
        final container = _container(profile: scorpio, now: now);
        final today = (await _load(container, cosmicTodayProvider('en')))!;
        return today.reading.headline;
      }

      final morning = await headlineAt(DateTime(2026, 10, 29, 6));
      final night = await headlineAt(DateTime(2026, 10, 29, 23, 59));
      final nextDay = await headlineAt(DateTime(2026, 10, 30, 6));
      expect(morning, night);
      expect(nextDay, isNot(morning));
    });

    test('uses English text for a language with none', () async {
      final container = _container(profile: scorpio);
      final today = (await _load(container, cosmicTodayProvider('my')))!;
      expect(today.reading.lang, 'en');
      expect(today.reading.isFallback, isTrue);
    });
  });

  group('showThaiColors', () {
    test('is off for English and on for Thai until the user chooses', () async {
      final container = _container();
      expect(await _load(container, showThaiColorsProvider('en')), isFalse);
      expect(await _load(container, showThaiColorsProvider('th')), isTrue);
    });

    test("keeps the user's choice over the language default", () async {
      final container = _container(
        thai: FakeThaiColorsSettingRepository(saved: false),
      );
      expect(await _load(container, showThaiColorsProvider('th')), isFalse);
    });

    test('saves a choice', () async {
      final thai = FakeThaiColorsSettingRepository();
      final container = _container(thai: thai);
      await _load(container, showThaiColorsProvider('en'));
      await container
          .read(showThaiColorsProvider('en').notifier)
          .set(enabled: true);
      expect(thai.saved, isTrue);
      expect(container.read(showThaiColorsProvider('en')).value, isTrue);
    });
  });
}
