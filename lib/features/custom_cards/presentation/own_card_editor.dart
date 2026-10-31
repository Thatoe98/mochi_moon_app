import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/custom_cards/domain/own_card.dart';
import 'package:mochi_moon/features/deck/presentation/share_quote.dart';

/// Opens the editor for a new card, or for [card] to change, share or delete.
Future<void> showOwnCardEditor(BuildContext context, {OwnCard? card}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => OwnCardEditor(card: card),
    );

/// Write up to 140 characters and pick one bundled picture (PRD §6.17).
class OwnCardEditor extends ConsumerStatefulWidget {
  const OwnCardEditor({this.card, super.key});

  final OwnCard? card;

  @override
  ConsumerState<OwnCardEditor> createState() => _OwnCardEditorState();
}

class _OwnCardEditorState extends ConsumerState<OwnCardEditor> {
  late final _controller = TextEditingController(text: widget.card?.body);
  late String _art =
      widget.card?.illustrationId ?? AppIllustrations.ownCardArt.keys.first;
  bool _saving = false;

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

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final rejection = await ref.read(saveOwnCardProvider)(
      _controller.text,
      _art,
      editId: widget.card?.id,
    );
    if (!mounted) return;
    if (rejection == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = false);
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          rejection == OwnCardRejection.limitReached
              ? l10n.ownCardsLimitBody
              : l10n.ownCardsCouldNotSave,
        ),
      ),
    );
  }

  Future<void> _delete(OwnCard card) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ownCardsDeleteTitle),
        content: Text(l10n.ownCardsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.ownCardsKeep),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.ownCardsDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(deleteOwnCardProvider)(card.id);
    if (mounted) Navigator.of(context).pop();
  }

  String _artLabel(AppLocalizations l10n, String id) => switch (id) {
    'confidence_01' => l10n.illustrationConfidence,
    'healing_01' => l10n.illustrationHealing,
    'selfworth_01' => l10n.illustrationSelfWorth,
    'rest_01' => l10n.illustrationRest,
    _ => l10n.illustrationCalm,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final card = widget.card;
    final length = _controller.text.runes.length;
    final canSave = _controller.text.trim().isNotEmpty && !_saving;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              card == null ? l10n.ownCardsNewTitle : l10n.ownCardsEditTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _controller,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [
                LengthLimitingTextInputFormatter(ownCardMaxLength),
              ],
              decoration: InputDecoration(
                hintText: l10n.ownCardsHint,
                counterText: '$length / $ownCardMaxLength',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.ownCardsPickArt, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final entry in AppIllustrations.ownCardArt.entries)
                  _ArtChoice(
                    asset: entry.value,
                    label: _artLabel(l10n, entry.key),
                    selected: entry.key == _art,
                    onTap: () => setState(() => _art = entry.key),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: canSave ? _save : null,
              child: Text(l10n.ownCardsSave),
            ),
            if (card != null) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => shareQuote(
                  context,
                  ref,
                  card.copyWith(illustrationId: _art).toQuote(),
                ),
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(l10n.ownCardsShare),
              ),
              TextButton(
                onPressed: () => _delete(card),
                child: Text(l10n.ownCardsDelete),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArtChoice extends StatelessWidget {
  const _ArtChoice({
    required this.asset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        borderRadius: AppRadii.chipRadius,
        onTap: onTap,
        child: Container(
          width: AppSpacing.minTouchTarget + AppSpacing.lg,
          height: AppSpacing.minTouchTarget + AppSpacing.lg,
          decoration: BoxDecoration(
            borderRadius: AppRadii.chipRadius,
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: AppRadii.chipRadius,
            child: ExcludeSemantics(
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
