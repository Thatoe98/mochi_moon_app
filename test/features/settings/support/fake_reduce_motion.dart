import 'package:mochi_moon/features/settings/domain/reduce_motion_setting.dart';

class FakeReduceMotionSettingRepository
    implements ReduceMotionSettingRepository {
  FakeReduceMotionSettingRepository({this.saved = false});

  bool saved;

  @override
  Future<bool> load() async => saved;

  @override
  Future<void> save({required bool enabled}) async => saved = enabled;
}
