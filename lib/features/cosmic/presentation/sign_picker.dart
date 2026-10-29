import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/presentation/zodiac_labels.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';

/// A row of the twelve signs to read another sign's page (Premium). The
/// user's own sign is marked and picking it goes back to their own page.
class SignPicker extends ConsumerWidget {
  const SignPicker({required this.shown, super.key});

  /// The sign whose page is on screen.
  final ZodiacSign shown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final own = ref.watch(userSunSignProvider).value;
    return Semantics(
      container: true,
      label: l10n.cosmicSignPickerLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final sign in ZodiacSign.values)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  selected: sign == shown,
                  label: Text(
                    sign == own
                        ? l10n.cosmicSignPickerYou(zodiacSignLabel(l10n, sign))
                        : zodiacSignLabel(l10n, sign),
                  ),
                  onSelected: (_) => ref
                      .read(viewedSignProvider.notifier)
                      .choose(sign == own ? null : sign),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
