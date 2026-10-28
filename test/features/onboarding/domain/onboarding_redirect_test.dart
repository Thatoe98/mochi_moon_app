import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/onboarding/domain/onboarding_repository.dart';

String? redirect({required bool complete, required String location}) =>
    onboardingRedirect(
      complete: complete,
      location: location,
      welcomeRoute: '/welcome',
      homeRoute: '/deck',
    );

void main() {
  group('first run', () {
    test('sends every other location to the welcome screen', () {
      for (final location in ['/deck', '/cosmic', '/me', '/me/journal']) {
        expect(redirect(complete: false, location: location), '/welcome');
      }
    });

    test('stays inside the welcome flow', () {
      expect(redirect(complete: false, location: '/welcome'), isNull);
      expect(redirect(complete: false, location: '/welcome/cards'), isNull);
    });
  });

  group('returning user', () {
    test('keeps every normal location', () {
      for (final location in ['/deck', '/cosmic', '/me', '/me/journal']) {
        expect(redirect(complete: true, location: location), isNull);
      }
    });

    test('is moved out of the welcome flow to the deck', () {
      expect(redirect(complete: true, location: '/welcome'), '/deck');
      expect(redirect(complete: true, location: '/welcome/cards'), '/deck');
    });
  });
}
