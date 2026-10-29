import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';

void main() {
  test('fromCode finds shipped languages', () {
    expect(AppLanguage.fromCode('en'), AppLanguage.english);
    expect(AppLanguage.fromCode('my'), AppLanguage.burmese);
  });

  test('fromCode follows the device for a missing or unknown code', () {
    expect(AppLanguage.fromCode(null), AppLanguage.system);
    expect(AppLanguage.fromCode('th'), AppLanguage.system);
    expect(AppLanguage.fromCode('zz'), AppLanguage.system);
  });

  test('system has no code of its own', () {
    expect(AppLanguage.system.code, isNull);
  });
}
