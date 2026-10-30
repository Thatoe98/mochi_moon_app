import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';

/// The app bar button (a stack of cards) that opens the twelve signs to read
/// another sign's page (Premium).
class SignPickerButton extends StatelessWidget {
  const SignPickerButton({required this.shown, super.key});

  /// The sign whose page is on screen.
  final ZodiacSign shown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n.cosmicSignPickerLabel,
      icon: const Icon(Icons.style_rounded),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => SignPickerSheet(shown: shown),
      ),
    );
  }
}

/// The twelve signs. The user's own is marked, and picking it goes back to
/// their own page.
class SignPickerSheet extends ConsumerWidget {
  const SignPickerSheet({required this.shown, super.key});

  final ZodiacSign shown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final own = ref.watch(userSunSignProvider).value;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.cosmicSignPickerLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final sign in ZodiacSign.values)
                  ChoiceChip(
                    selected: sign == shown,
                    label: Text(
                      sign == own
                          ? l10n.cosmicSignPickerYou(
                              zodiacSignLabel(l10n, sign),
                            )
                          : zodiacSignLabel(l10n, sign),
                    ),
                    onSelected: (_) {
                      ref
                          .read(viewedSignProvider.notifier)
                          .choose(sign == own ? null : sign);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
