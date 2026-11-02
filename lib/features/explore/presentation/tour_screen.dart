import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/feature_tile.dart';
import 'package:mochi_moon/features/explore/application/tips_providers.dart';

/// "How Mochi works": four short cards. Never forced; she can skip or replay
/// it from Me.
class TourScreen extends ConsumerStatefulWidget {
  const TourScreen({super.key});

  @override
  ConsumerState<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends ConsumerState<TourScreen> {
  final _controller = PageController();
  var _page = 0;

  static const List<IconData> _icons = [
    Icons.wb_sunny_rounded,
    Icons.style_rounded,
    Icons.grid_view_rounded,
    Icons.nightlight_rounded,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(tourSeenProvider.notifier).markSeen();
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.today);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accents = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.primary,
    ];
    final titles = [
      l10n.tourPage1Title,
      l10n.tourPage2Title,
      l10n.tourPage3Title,
      l10n.tourPage4Title,
    ];
    final bodies = [
      l10n.tourPage1Body,
      l10n.tourPage2Body,
      l10n.tourPage3Body,
      l10n.tourPage4Body,
    ];
    final last = _page == titles.length - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tourTitle),
        actions: [
          if (!last) TextButton(onPressed: _finish, child: Text(l10n.tourSkip)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: titles.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) => SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      IconBadge(
                        icon: _icons[index],
                        color: accents[index],
                        size: AppSpacing.xxl * 2,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Semantics(
                        header: true,
                        child: Text(
                          titles[index],
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        bodies[index],
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < titles.length; i++)
                  Container(
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    margin: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: last
                      ? _finish
                      : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                  child: Text(last ? l10n.tourDone : l10n.tourNext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
