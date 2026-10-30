import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/application/announcements_providers.dart';
import 'package:mochi_moon/features/settings/presentation/announcements_section.dart';

import '../support/fake_announcements.dart';

Widget _host(
  FakeAnnouncementsSettingRepository repository,
  FakeAnnouncementsTopic topic,
) => ProviderScope(
  overrides: [
    announcementsSettingRepositoryProvider.overrideWithValue(repository),
    announcementsTopicProvider.overrideWithValue(topic),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: AnnouncementsSection()),
  ),
);

bool _switchValue(WidgetTester tester) =>
    tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value;

void main() {
  testWidgets('is on by default', (tester) async {
    await tester.pumpWidget(
      _host(FakeAnnouncementsSettingRepository(), FakeAnnouncementsTopic()),
    );
    await tester.pumpAndSettle();

    expect(find.text('App news'), findsOneWidget);
    expect(_switchValue(tester), isTrue);
  });

  testWidgets('shows a saved off', (tester) async {
    await tester.pumpWidget(
      _host(
        FakeAnnouncementsSettingRepository(saved: false),
        FakeAnnouncementsTopic(),
      ),
    );
    await tester.pumpAndSettle();

    expect(_switchValue(tester), isFalse);
  });

  testWidgets('switching it off saves it and leaves the topic', (tester) async {
    final repository = FakeAnnouncementsSettingRepository();
    final topic = FakeAnnouncementsTopic();
    await tester.pumpWidget(_host(repository, topic));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(repository.saved, isFalse);
    expect(topic.calls, ['unsubscribe']);
    expect(_switchValue(tester), isFalse);
  });

  testWidgets('survives large text', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: _host(
          FakeAnnouncementsSettingRepository(),
          FakeAnnouncementsTopic(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
