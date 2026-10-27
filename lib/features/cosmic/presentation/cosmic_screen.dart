import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';

/// Placeholder until Cosmic Today lands (PRD M2).
class CosmicScreen extends StatelessWidget {
  const CosmicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cosmicPlaceholderTitle)),
      body: EmptyState(
        title: l10n.cosmicPlaceholderTitle,
        body: l10n.cosmicPlaceholderBody,
      ),
    );
  }
}
