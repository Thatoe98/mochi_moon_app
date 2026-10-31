import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';

/// Each language is named in its own language, whatever the app language is,
/// so these two names are not in the ARB files.
const _englishName = 'English';
const _burmeseName = 'မြန်မာ';

/// The label for [language] in pickers.
String languageName(AppLanguage language, AppLocalizations l10n) =>
    switch (language) {
      AppLanguage.system => l10n.languageSystem,
      AppLanguage.english => _englishName,
      AppLanguage.burmese => _burmeseName,
    };
