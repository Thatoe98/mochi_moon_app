import 'package:mochi_moon/features/settings/domain/app_language.dart';

class FakeAppLanguageRepository implements AppLanguageRepository {
  FakeAppLanguageRepository({this.saved = AppLanguage.system});

  AppLanguage saved;

  @override
  Future<AppLanguage> load() async => saved;

  @override
  Future<void> save(AppLanguage language) async => saved = language;
}
