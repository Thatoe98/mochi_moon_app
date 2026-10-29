import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';

/// The always-visible way into the Retrogrades screen (PRD §6.8). It does not
/// wait for the calendar, so it is there the moment the tab opens.
class RetrogradeButton extends StatelessWidget {
  const RetrogradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.retroCardHint,
      child: TextButton.icon(
        onPressed: () => context.push(AppRoutes.retrogrades),
        icon: const Icon(Icons.published_with_changes_rounded),
        label: Text(l10n.retroTitle),
      ),
    );
  }
}
