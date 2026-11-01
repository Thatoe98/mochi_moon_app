import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/analytics/analytics_event.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/presentation/share_image_renderer.dart';
import 'package:mochi_moon/features/recap/application/recap_providers.dart';
import 'package:mochi_moon/features/recap/presentation/recap_content.dart';

/// Renders the recap on the device and opens the share sheet. Nothing is
/// uploaded. A failure shows a snack bar instead of throwing.
Future<void> shareRecap(
  BuildContext context,
  WidgetRef ref,
  RecapView view,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final sharer = ref.read(imageSharerProvider);
  final analytics = ref.read(analyticsLoggerProvider);
  try {
    final png = await renderShareImage(
      context,
      // Always the light theme, so a shared image looks the same for everyone.
      Theme(data: AppTheme.light, child: buildRecapImage(context, view)),
    );
    final month = view.recap.month;
    await sharer.sharePng(
      png,
      fileName: 'mochi_moon_recap_${month.year}_${month.month}.png',
    );
    await analytics.log(AnalyticsEvent.recapShared);
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
  }
}
