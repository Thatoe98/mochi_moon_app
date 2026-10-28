import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';

/// The thumbnail is laid out at 128x128 and captured at 2x. RemoteViews
/// bitmaps share a small binder budget, so this stays far below the 1080x1920
/// share image.
const widgetThumbnailSize = Size(128, 128);
const widgetThumbnailPixelRatio = 2.0;

/// A card's illustration, rounded, as painted into the home-screen widget.
///
/// It is rendered outside the app's widget tree, so it brings its own theme,
/// media query and localizations.
class WidgetThumbnail extends StatelessWidget {
  const WidgetThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Localizations(
          locale: const Locale('en'),
          delegates: AppLocalizations.localizationsDelegates,
          child: SizedBox.fromSize(
            size: widgetThumbnailSize,
            child: const ClipRRect(
              borderRadius: AppRadii.cardRadius,
              child: IllustrationPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}
