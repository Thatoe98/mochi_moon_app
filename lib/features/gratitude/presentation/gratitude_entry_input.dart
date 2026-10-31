import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';

/// A box to write one entry for the jar (PRD §6.16): up to 200 characters and
/// up to three a day. Once the day is full it says so kindly instead.
class GratitudeEntryInput extends ConsumerStatefulWidget {
  const GratitudeEntryInput({this.onAdded, super.key});

  /// Called after an entry was added.
  final VoidCallback? onAdded;

  @override
  ConsumerState<GratitudeEntryInput> createState() =>
      _GratitudeEntryInputState();
}

class _GratitudeEntryInputState extends ConsumerState<GratitudeEntryInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _controller.text;
    final rejection = await ref.read(addGratitudeProvider)(text);
    if (rejection != null || !mounted) return;
    _controller.clear();
    widget.onAdded?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final full = ref.watch(gratitudeCountTodayProvider) >= gratitudePerDay;
    if (full) {
      return Text(l10n.gratitudeDayFull, style: theme.textTheme.bodyLarge);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          maxLength: gratitudeMaxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.gratitudeHint),
        ),
        Text(l10n.gratitudePrivacyNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty ? null : _add,
          child: Text(l10n.gratitudeAdd),
        ),
      ],
    );
  }
}
