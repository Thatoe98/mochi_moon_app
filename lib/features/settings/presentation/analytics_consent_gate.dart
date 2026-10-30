import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';

/// Asks the analytics question once, the first time the main screens show
/// (PRD §6.14). Both answers are equally easy and can be changed in Me.
class AnalyticsConsentGate extends ConsumerStatefulWidget {
  const AnalyticsConsentGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AnalyticsConsentGate> createState() =>
      _AnalyticsConsentGateState();
}

class _AnalyticsConsentGateState extends ConsumerState<AnalyticsConsentGate> {
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(analyticsConsentControllerProvider, (_, next) {
      if (next.hasValue && next.value == null) _ask();
    }, fireImmediately: true);
  }

  void _ask() {
    if (_asking) return;
    _asking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final granted = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(l10n.analyticsConsentTitle),
            content: Text(l10n.analyticsConsentBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.analyticsConsentDecline),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.analyticsConsentAllow),
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      await ref
          .read(analyticsConsentControllerProvider.notifier)
          .set(granted: granted ?? false);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
