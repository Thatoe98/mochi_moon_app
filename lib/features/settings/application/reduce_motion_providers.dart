import 'package:mochi_moon/features/settings/data/prefs_reduce_motion_setting_repository.dart';
import 'package:mochi_moon/features/settings/domain/reduce_motion_setting.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'reduce_motion_providers.g.dart';

@Riverpod(keepAlive: true)
ReduceMotionSettingRepository reduceMotionSettingRepository(Ref ref) =>
    PrefsReduceMotionSettingRepository(SharedPreferencesAsync());

/// Whether the user switched "Reduce motion" on, kept in sync with what is
/// saved. The system setting is separate: widgets read it from `MediaQuery`,
/// and the app turns this switch into the same signal (see `app.dart`).
@Riverpod(keepAlive: true)
class ReduceMotionController extends _$ReduceMotionController {
  @override
  Future<bool> build() =>
      ref.watch(reduceMotionSettingRepositoryProvider).load();

  Future<void> set({required bool enabled}) async {
    await ref
        .read(reduceMotionSettingRepositoryProvider)
        .save(enabled: enabled);
    state = AsyncData(enabled);
  }
}
