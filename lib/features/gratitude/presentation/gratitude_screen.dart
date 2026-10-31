import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/presentation/gratitude_entry_input.dart';
import 'package:mochi_moon/features/gratitude/presentation/gratitude_jar.dart';

/// Me → Gratitude jar (PRD §6.16): add up to three entries a day, watch the
/// jar fill, open it to read a random earlier one, and delete entries.
class GratitudeScreen extends ConsumerStatefulWidget {
  const GratitudeScreen({super.key});

  @override
  ConsumerState<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends ConsumerState<GratitudeScreen> {
  /// The earlier entries in the order they are shown once the jar is open.
  List<GratitudeNote>? _opened;
  int _position = 0;

  void _open(List<GratitudeNote> entries) {
    final today = ref.read(clockProvider)();
    setState(() {
      _opened = shuffledPast(entries, today);
      _position = 0;
    });
  }

  Future<void> _confirmDelete(GratitudeNote entry) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.gratitudeDeleteTitle),
        content: Text(l10n.gratitudeDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.gratitudeCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.gratitudeDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(deleteGratitudeProvider)(entry.id);
      if (mounted) setState(() => _opened = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final entries = ref.watch(gratitudeEntriesProvider);
    final today = ref.watch(clockProvider)();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gratitudeTitle)),
      body: entries.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(gratitudeEntriesProvider)),
        data: (all) {
          final todays = [
            for (final e in all)
              if (gratitudeCountOn([e], today) == 1) e,
          ];
          final earlier = [
            for (final e in all)
              if (!todays.contains(e)) e,
          ];
          final opened = _opened;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Center(child: GratitudeJar(count: all.length)),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.gratitudeJarCount(all.length),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (all.isEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                const _EmptyInvitation(),
              ],
              const SizedBox(height: AppSpacing.lg),
              const GratitudeEntryInput(),
              const SizedBox(height: AppSpacing.lg),
              if (opened != null)
                _OpenedEntry(
                  entry: opened.isEmpty ? null : opened[_position],
                  onAnother: opened.length > 1
                      ? () => setState(
                          () => _position = (_position + 1) % opened.length,
                        )
                      : null,
                  onClose: () => setState(() => _opened = null),
                )
              else if (all.isNotEmpty)
                OutlinedButton(
                  onPressed: () => _open(all),
                  child: Text(l10n.gratitudeOpenJar),
                ),
              if (todays.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _Section(
                  title: l10n.gratitudeTodayHeader,
                  entries: todays,
                  onDelete: _confirmDelete,
                ),
              ],
              if (earlier.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _Section(
                  title: l10n.gratitudeEarlierHeader,
                  entries: earlier,
                  onDelete: _confirmDelete,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyInvitation extends StatelessWidget {
  const _EmptyInvitation();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: AppRadii.cardRadius,
              child: MochiIllustration(
                asset: AppIllustrations.emptyDeck,
                semanticLabel: l10n.illustrationEmptyDeck,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.gratitudeEmptyTitle,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.gratitudeEmptyBody,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OpenedEntry extends StatelessWidget {
  const _OpenedEntry({
    required this.entry,
    required this.onAnother,
    required this.onClose,
  });

  final GratitudeNote? entry;
  final VoidCallback? onAnother;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry?.body ?? l10n.gratitudeNothingYet,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (onAnother != null)
                  FilledButton(
                    onPressed: onAnother,
                    child: Text(l10n.gratitudeAnother),
                  ),
                TextButton(
                  onPressed: onClose,
                  child: Text(l10n.gratitudeCloseJar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.entries,
    required this.onDelete,
  });

  final String title;
  final List<GratitudeNote> entries;
  final void Function(GratitudeNote entry) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final entry in entries)
          ListTile(
            minTileHeight: AppSpacing.minTouchTarget,
            contentPadding: EdgeInsets.zero,
            leading: const ExcludeSemantics(
              child: Icon(Icons.auto_awesome_rounded),
            ),
            title: Text(entry.body),
            trailing: IconButton(
              tooltip: l10n.gratitudeDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => onDelete(entry),
            ),
          ),
      ],
    );
  }
}
