import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/domain/app_language.dart';

/// Each language is named in its own language, whatever the app language is,
/// so these two names are not in the ARB files.
const _englishName = 'English';
const _burmeseName = 'မြန်မာ';

String _nameOf(AppLanguage language, AppLocalizations l10n) =>
    switch (language) {
      AppLanguage.system => l10n.languageSystem,
      AppLanguage.english => _englishName,
      AppLanguage.burmese => _burmeseName,
    };

/// The Me-tab row that shows the app language and opens the choice sheet.
class LanguageSection extends ConsumerWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(languageControllerProvider);
    final current = loaded.value ?? AppLanguage.system;
    return ListTile(
      minTileHeight: AppSpacing.minTouchTarget,
      leading: const Icon(Icons.language_rounded),
      title: Text(l10n.languageTitle),
      subtitle: Text(_nameOf(current, l10n)),
      trailing: const Icon(Icons.chevron_right_rounded),
      enabled: loaded.hasValue,
      onTap: () => _choose(context, ref, current),
    );
  }

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    AppLanguage current,
  ) async {
    final chosen = await showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (context) => _LanguageSheet(current: current),
    );
    if (chosen != null && chosen != current) {
      await ref.read(languageControllerProvider.notifier).select(chosen);
    }
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.current});

  final AppLanguage current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final language in AppLanguage.values)
            ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              title: Text(_nameOf(language, l10n)),
              selected: language == current,
              trailing: language == current
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.of(context).pop(language),
            ),
        ],
      ),
    );
  }
}
