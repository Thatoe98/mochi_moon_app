import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/features/deck/presentation/category_label.dart';
import 'package:mochi_moon/features/onboarding/application/profile_setup.dart';
import 'package:mochi_moon/features/onboarding/domain/profile_setup_state.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';
import 'package:mochi_moon/features/settings/domain/reminder.dart';

/// The content of the current profile step.
class ProfileStepBody extends StatelessWidget {
  const ProfileStepBody({
    required this.setup,
    required this.notifier,
    super.key,
  });

  final ProfileSetupState setup;
  final ProfileSetup notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (setup.step) {
      ProfileStep.name => _Step(
        title: l10n.profileNameTitle,
        body: l10n.profileNameBody,
        child: _NameField(
          initial: setup.name,
          onChanged: notifier.setName,
          onSubmitted: notifier.next,
        ),
      ),
      ProfileStep.reminder => _Step(
        title: l10n.profileReminderTitle,
        body: l10n.profileReminderBody,
        child: _ReminderTime(
          time: setup.reminderTime,
          onChanged: notifier.setReminderTime,
        ),
      ),
      ProfileStep.focus => _Step(
        title: l10n.profileFocusTitle,
        body: l10n.profileFocusBody(maxFocusAreas),
        child: FocusAreaChips(
          selected: setup.focusAreas,
          onToggle: notifier.toggleFocus,
        ),
      ),
    };
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.title, required this.body, required this.child});

  final String title;
  final String body;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(body, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        child,
      ],
    );
  }
}

class _NameField extends StatefulWidget {
  const _NameField({
    required this.initial,
    required this.onChanged,
    required this.onSubmitted,
  });

  final String initial;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    autofocus: true,
    textCapitalization: TextCapitalization.words,
    textInputAction: TextInputAction.next,
    maxLength: 40,
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context).profileNameLabel,
    ),
    onChanged: widget.onChanged,
    onSubmitted: (_) => widget.onSubmitted(),
  );
}

class BirthDatePicker extends StatelessWidget {
  const BirthDatePicker({
    required this.chosen,
    required this.today,
    required this.onChanged,
    super.key,
  });

  final DateTime? chosen;
  final DateTime today;
  final ValueChanged<DateTime> onChanged;

  /// Where the calendar opens before anything is chosen. Nothing counts as
  /// chosen until the user taps a day, so Continue stays off.
  static final _opensAt = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        CalendarDatePicker(
          initialDate: chosen ?? _opensAt,
          firstDate: DateTime(earliestBirthYear),
          lastDate: DateUtils.dateOnly(today),
          initialCalendarMode: DatePickerMode.year,
          onDateChanged: onChanged,
        ),
        if (chosen != null)
          Text(
            l10n.profileBirthDateChosen(englishDates.formatMediumDate(chosen!)),
            style: Theme.of(context).textTheme.titleMedium,
          ),
      ],
    );
  }
}

/// Picks a birth time, or "I don't know" (null).
class BirthTimePicker extends StatelessWidget {
  const BirthTimePicker({
    required this.minutes,
    required this.onChanged,
    super.key,
  });

  final int? minutes;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final time = minutes == null
        ? null
        : TimeOfDay(hour: minutes! ~/ 60, minute: minutes! % 60);

    Future<void> pick() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: time ?? const TimeOfDay(hour: 12, minute: 0),
      );
      if (picked != null) onChanged(picked.hour * 60 + picked.minute);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          time == null
              ? l10n.profileBirthTimeNone
              : l10n.profileBirthTimeChosen(englishDates.formatTimeOfDay(time)),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: pick,
          child: Text(
            time == null
                ? l10n.profileBirthTimeChoose
                : l10n.profileBirthTimeChange,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: time == null ? null : () => onChanged(null),
          child: Text(l10n.profileBirthTimeUnknown),
        ),
      ],
    );
  }
}

class _ReminderTime extends StatelessWidget {
  const _ReminderTime({required this.time, required this.onChanged});

  final ReminderTime time;
  final ValueChanged<ReminderTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final of = TimeOfDay(hour: time.hour, minute: time.minute);

    Future<void> pick() async {
      final picked = await showTimePicker(context: context, initialTime: of);
      if (picked != null) onChanged(ReminderTime(picked.hour, picked.minute));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.profileReminderAt(englishDates.formatTimeOfDay(of)),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: pick,
          child: Text(l10n.profileReminderChange),
        ),
      ],
    );
  }
}

/// The focus-area chips; at most [maxFocusAreas] can be on.
class FocusAreaChips extends StatelessWidget {
  const FocusAreaChips({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final List<FocusArea> selected;
  final ValueChanged<FocusArea> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final full = selected.length >= maxFocusAreas;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final area in FocusArea.values)
          FilterChip(
            label: Text(categoryLabel(l10n, area.id) ?? area.id),
            selected: selected.contains(area),
            // Once three are picked the rest can only be reached by
            // un-picking one.
            onSelected: full && !selected.contains(area)
                ? null
                : (_) => onToggle(area),
          ),
      ],
    );
  }
}
