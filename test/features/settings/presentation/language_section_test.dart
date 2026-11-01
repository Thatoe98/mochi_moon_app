import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';
import 'package:mochi_moon/features/settings/presentation/language_section.dart';

import '../support/fake_app_language.dart';

/// Mirrors the app root: the locale comes from the language provider.
class _Host extends ConsumerWidget {
  const _Host();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    locale: ref.watch(appLocaleProvider),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const Scaffold(body: LanguageSection()),
  );
}

Widget _host(FakeAppLanguageRepository repository) => ProviderScope(
  overrides: [
    appLanguageRepositoryProvider.overrideWithValue(repository),
    burmeseEnabledProvider.overrideWithValue(true),
  ],
  child: const _Host(),
);

void main() {
  testWidgets('shows the current language and lists the choices', (
    tester,
  ) async {
    final repository = FakeAppLanguageRepository(saved: AppLanguage.english);
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('Same as my phone'), findsOneWidget);
    expect(find.text('မြန်မာ'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('choosing Burmese saves it and switches the whole screen', (
    tester,
  ) async {
    final repository = FakeAppLanguageRepository(saved: AppLanguage.english);
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('မြန်မာ'));
    await tester.pumpAndSettle();

    expect(repository.saved, AppLanguage.burmese);
    expect(find.text('Language'), findsNothing);
    expect(find.text('ဘာသာစကား'), findsOneWidget);
    expect(find.text('မြန်မာ'), findsOneWidget);
  });

  testWidgets('picking the language already in use changes nothing', (
    tester,
  ) async {
    final repository = FakeAppLanguageRepository(saved: AppLanguage.english);
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(repository.saved, AppLanguage.english);
    expect(find.text('Language'), findsOneWidget);
  });

  testWidgets('dismissing the sheet changes nothing', (tester) async {
    final repository = FakeAppLanguageRepository(saved: AppLanguage.burmese);
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ဘာသာစကား'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(repository.saved, AppLanguage.burmese);
    expect(find.text('ဘာသာစကား'), findsOneWidget);
  });
}
