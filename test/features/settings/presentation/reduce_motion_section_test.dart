import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/reduce_motion_providers.dart';
import 'package:mochi_moon/features/settings/presentation/reduce_motion_section.dart';

import '../support/fake_reduce_motion.dart';

Widget _host(FakeReduceMotionSettingRepository repository) => ProviderScope(
  overrides: [
    reduceMotionSettingRepositoryProvider.overrideWithValue(repository),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: ReduceMotionSection()),
  ),
);

void main() {
  testWidgets('shows the switch off by default', (tester) async {
    await tester.pumpWidget(_host(FakeReduceMotionSettingRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Reduce motion'), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );
  });

  testWidgets('shows a saved choice', (tester) async {
    await tester.pumpWidget(
      _host(FakeReduceMotionSettingRepository(saved: true)),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );
  });

  testWidgets('switching it on saves it', (tester) async {
    final repository = FakeReduceMotionSettingRepository();
    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(repository.saved, isTrue);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );
  });
}
