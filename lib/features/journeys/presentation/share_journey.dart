import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/deck/presentation/share_card_image.dart';
import 'package:mochi_moon/features/deck/presentation/share_image_renderer.dart';

const _shareCategory = 'self_love';

/// Renders "I finished the [title] journey" as a story image and opens the
/// system share sheet. A failure shows a snack bar instead of throwing.
Future<void> shareJourneyComplete(
  BuildContext context,
  WidgetRef ref,
  String title,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final sharer = ref.read(imageSharerProvider);
  final handle = ref.read(shareHandleProvider);
  try {
    await precacheImage(
      AssetImage(AppIllustrations.forCard(_shareCategory, null)),
      context,
    );
    if (!context.mounted) return;
    final png = await renderShareImage(
      context,
      Theme(
        data: AppTheme.light,
        child: ShareCardImage(
          text: l10n.journeyShareText(title),
          category: _shareCategory,
          categoryLabel: categoryLabel(l10n, _shareCategory),
          wordmark: l10n.appName,
          handle: handle,
        ),
      ),
    );
    await sharer.sharePng(png, fileName: 'mochi_moon_journey.png');
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
  }
}
