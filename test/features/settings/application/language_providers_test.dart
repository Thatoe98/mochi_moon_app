import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';

import '../support/fake_app_language.dart';

ProviderContainer _container(FakeAppLanguageRepository repository) {
  final container = ProviderContainer(
    overrides: [
      appLanguageRepositoryProvider.overrideWithValue(repository),
      burmeseEnabledProvider.overrideWithValue(true),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('follows the device until the user chooses', () async {
    final container = _container(FakeAppLanguageRepository());
    expect(await container.read(languageControllerProvider.future), isNotNull);

    expect(container.read(appLocaleProvider), isNull);
    expect(container.read(effectiveLanguageProvider), isIn(['en', 'my']));
  });

  test('a saved choice forces the locale from the first read', () async {
    final container = _container(
      FakeAppLanguageRepository(saved: AppLanguage.burmese),
    );
    await container.read(languageControllerProvider.future);

    expect(container.read(appLocaleProvider), const Locale('my'));
    expect(container.read(effectiveLanguageProvider), 'my');
  });

  test('select saves the choice and switches the locale', () async {
    final repository = FakeAppLanguageRepository();
    final container = _container(repository);
    await container.read(languageControllerProvider.future);
    final locales = <Locale?>[];
    container.listen(appLocaleProvider, (_, next) => locales.add(next));

    final controller = container.read(languageControllerProvider.notifier);
    await controller.select(AppLanguage.burmese);
    await container.pump();
    await controller.select(AppLanguage.english);
    await container.pump();
    await controller.select(AppLanguage.system);
    await container.pump();

    expect(repository.saved, AppLanguage.system);
    expect(locales, [const Locale('my'), const Locale('en'), null]);
    expect(container.read(effectiveLanguageProvider), isIn(['en', 'my']));
  });

  test('effectiveLanguage is the chosen code', () async {
    final container = _container(FakeAppLanguageRepository());
    await container.read(languageControllerProvider.future);
    await container
        .read(languageControllerProvider.notifier)
        .select(AppLanguage.english);

    expect(container.read(effectiveLanguageProvider), 'en');
  });
}
