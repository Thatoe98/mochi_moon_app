import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/network/network_providers.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/url_opener.dart';
import 'package:mochi_moon/features/settings/domain/legal_links.dart';

/// "About readings", privacy policy, terms and the open-source licenses
/// (PRD §6.14).
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, Uri url) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).aboutLinkFailed;
    final opened = await ref.read(urlOpenerProvider)(url);
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final baseUrl = ref.watch(readingsApiBaseUrlProvider);
    final privacyUrl = legalUrl(baseUrl, LegalPage.privacy);
    final termsUrl = legalUrl(baseUrl, LegalPage.terms);
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
          if (privacyUrl != null)
            ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_rounded),
              title: Text(l10n.aboutPrivacy),
              trailing: const Icon(Icons.open_in_new_rounded),
              onTap: () => _open(context, ref, privacyUrl),
            ),
          if (termsUrl != null)
            ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.gavel_rounded),
              title: Text(l10n.aboutTerms),
              trailing: const Icon(Icons.open_in_new_rounded),
              onTap: () => _open(context, ref, termsUrl),
            ),
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
