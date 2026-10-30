import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/application/announcements_providers.dart';

import '../support/fake_announcements.dart';

ProviderContainer _container(
  FakeAnnouncementsSettingRepository repository,
  FakeAnnouncementsTopic topic,
) {
  final container = ProviderContainer(
    overrides: [
      announcementsSettingRepositoryProvider.overrideWithValue(repository),
      announcementsTopicProvider.overrideWithValue(topic),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('is on until the user switches it off', () async {
    final container = _container(
      FakeAnnouncementsSettingRepository(),
      FakeAnnouncementsTopic(),
    );

    expect(
      await container.read(announcementsControllerProvider.future),
      isTrue,
    );
  });

  test('switching it off saves it and leaves the topic', () async {
    final repository = FakeAnnouncementsSettingRepository();
    final topic = FakeAnnouncementsTopic();
    final container = _container(repository, topic);
    await container.read(announcementsControllerProvider.future);

    await container
        .read(announcementsControllerProvider.notifier)
        .set(enabled: false);

    expect(repository.saved, isFalse);
    expect(topic.calls, ['unsubscribe']);
    expect(container.read(announcementsControllerProvider).value, isFalse);
  });

  test('switching it back on joins the topic again', () async {
    final repository = FakeAnnouncementsSettingRepository(saved: false);
    final topic = FakeAnnouncementsTopic();
    final container = _container(repository, topic);
    await container.read(announcementsControllerProvider.future);

    await container
        .read(announcementsControllerProvider.notifier)
        .set(enabled: true);

    expect(repository.saved, isTrue);
    expect(topic.calls, ['subscribe']);
  });

  test('the app-open sync joins the topic when it is on', () async {
    final topic = FakeAnnouncementsTopic();
    final container = _container(FakeAnnouncementsSettingRepository(), topic);

    await container.read(announcementsSyncProvider.future);

    expect(topic.calls, ['subscribe']);
  });

  test('the app-open sync keeps the topic left when it is off', () async {
    final topic = FakeAnnouncementsTopic();
    final container = _container(
      FakeAnnouncementsSettingRepository(saved: false),
      topic,
    );

    await container.read(announcementsSyncProvider.future);

    expect(topic.calls, ['unsubscribe']);
  });

  test('a topic that cannot be reached still keeps the choice', () async {
    final repository = FakeAnnouncementsSettingRepository();
    final topic = FakeAnnouncementsTopic(failWith: Exception('offline'));
    final container = _container(repository, topic);
    await container.read(announcementsControllerProvider.future);

    await container
        .read(announcementsControllerProvider.notifier)
        .set(enabled: false);

    expect(repository.saved, isFalse);
    expect(container.read(announcementsControllerProvider).value, isFalse);
    await expectLater(
      container.read(announcementsSyncProvider.future),
      completes,
    );
  });
}
