import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_labels.dart';

/// The six moods as choice chips; [selected] is highlighted and picking one
/// calls [onSelected]. Picking the chosen one again keeps it.
class MoodChips extends StatelessWidget {
  const MoodChips({
    required this.selected,
    required this.onSelected,
    this.scrollable = false,
    super.key,
  });

  final Mood? selected;
  final ValueChanged<Mood> onSelected;

  /// One row she can scroll sideways instead of wrapped rows.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = [
      for (final mood in Mood.values)
        ChoiceChip(
          avatar: ExcludeSemantics(child: Text(mood.emoji)),
          label: Text(mood.label(l10n)),
          selected: mood == selected,
          showCheckmark: false,
          onSelected: (_) => onSelected(mood),
        ),
    ];
    if (!scrollable) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: chips,
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips) ...[
            chip,
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
