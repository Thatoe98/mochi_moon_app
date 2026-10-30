import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// "About readings" and the open-source licenses (PRD §6.14).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final sections = [
      (l10n.aboutReadingsTitle, l10n.aboutReadingsBody),
      (l10n.aboutZodiacTitle, l10n.aboutZodiacBody),
      (l10n.aboutWritingTitle, l10n.aboutWritingBody),
      (l10n.aboutCareTitle, l10n.aboutCareBody),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          for (final (title, body) in sections) ...[
            Semantics(
              header: true,
              child: Text(title, style: text.titleMedium),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(body, style: text.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(l10n.cosmicDisclaimer, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_rounded),
            title: Text(l10n.aboutLicenses),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appName,
            ),
          ),
        ],
      ),
    );
  }
}
