import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';

/// Placeholder until Journal and Settings land (PRD M1/M2).
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mePlaceholderTitle)),
      body: EmptyState(
        title: l10n.mePlaceholderTitle,
        body: l10n.mePlaceholderBody,
      ),
    );
  }
}
