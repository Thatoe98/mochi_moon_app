import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';
import 'package:mochi_moon/features/deck/presentation/share_image_renderer.dart';

/// Renders [quote] as a story image and opens the system share sheet.
/// A failure shows a snack bar instead of throwing.
Future<void> shareQuote(
  BuildContext context,
  WidgetRef ref,
  Quote quote,
) async {
  final l10n = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final messenger = ScaffoldMessenger.of(context);
  final sharer = ref.read(imageSharerProvider);
  final handle = ref.read(shareHandleProvider);
  try {
    // The art decodes asynchronously; without this the capture can be blank.
    await precacheImage(
      AssetImage(
        AppIllustrations.forCard(quote.category, quote.illustrationId),
      ),
      context,
    );
    if (!context.mounted) return;
    final png = await renderShareImage(
      context,
      // Always the light theme, so a shared image looks the same for everyone.
      Theme(
        data: AppTheme.light,
        child: ShareCardImage(
          text: quote.textFor(lang),
          category: quote.category,
          illustrationId: quote.illustrationId,
          categoryLabel: categoryLabel(l10n, quote.category),
          wordmark: l10n.appName,
          handle: handle,
        ),
      ),
    );
    await sharer.sharePng(png, fileName: 'mochi_moon_${quote.id}.png');
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
  }
}
