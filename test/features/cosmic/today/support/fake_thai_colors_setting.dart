import 'package:mochi_moon/features/cosmic/today/domain/thai_colors_setting.dart';

/// In-memory [ThaiColorsSettingRepository] for tests.
class FakeThaiColorsSettingRepository implements ThaiColorsSettingRepository {
  FakeThaiColorsSettingRepository({this.saved});

  bool? saved;

  @override
  Future<bool?> load() async => saved;

  @override
  Future<void> save({required bool enabled}) async => saved = enabled;
}
