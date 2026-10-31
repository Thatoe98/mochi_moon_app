import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/future_letter.dart';

/// Writes and seals a letter (PRD §6.22). Sealing asks once more, because a
/// sealed letter cannot be read or changed until its day.
class WriteLetterScreen extends ConsumerStatefulWidget {
  const WriteLetterScreen({super.key});

  @override
  ConsumerState<WriteLetterScreen> createState() => _WriteLetterScreenState();
}

class _WriteLetterScreenState extends ConsumerState<WriteLetterScreen> {
  final _controller = TextEditingController();
  int _days = letterUnlockChoices.first;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _date(DateTime value) =>
      DateFormat.yMMMd(Localizations.localeOf(context).toString())
          .format(value);

  Future<void> _seal() async {
    final l10n = AppLocalizations.of(context);
    final opensOn = _date(letterUnlockAt(ref.read(clockProvider)(), _days));
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.letterSealConfirmTitle),
        content: Text(l10n.letterSealConfirmBody(opensOn)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.letterSealConfirmNo),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.letterSealConfirmYes),
          ),
        ],
      ),
    );
    if (!(ok ?? false) || !mounted) return;
    setState(() => _saving = true);
    final outcome = await ref.read(sealLetterActionProvider)(
      _controller.text,
      _days,
    );
    if (!mounted) return;
    if (outcome.rejection != null) {
      setState(() => _saving = false);
      return;
    }
    if (!outcome.reminderOn) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.letterNoReminder(opensOn))),
      );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.letterWriteTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            controller: _controller,
            maxLength: letterMaxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            minLines: 6,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: l10n.letterHint),
          ),
          Text(l10n.letterPrivacyNote, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.letterDelayLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final days in letterUnlockChoices)
                ChoiceChip(
                  label: Text(l10n.letterDelayDays(days)),
                  selected: _days == days,
                  onSelected: (_) => setState(() => _days = days),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving || _controller.text.trim().isEmpty
                ? null
                : _seal,
            child: Text(l10n.letterSeal),
          ),
        ],
      ),
    );
  }
}
