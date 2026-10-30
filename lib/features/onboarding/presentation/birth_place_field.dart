import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';

/// Birthplace search over the bundled cities list (PRD §6.1). Once a place is
/// chosen it shows as a card with a way to pick another.
class BirthPlaceField extends ConsumerStatefulWidget {
  const BirthPlaceField({
    required this.chosen,
    required this.onChosen,
    this.autofocus = true,
    super.key,
  });

  final BirthPlace? chosen;

  /// Whether the search box takes focus when it shows. Off in a longer form,
  /// where it would pull the keyboard away from the other fields.
  final bool autofocus;

  /// Called with the picked city, or null when the user clears the choice.
  final ValueChanged<City?> onChosen;

  /// Most matches listed under the field.
  static const maxResults = 8;

  @override
  ConsumerState<BirthPlaceField> createState() => _BirthPlaceFieldState();
}

class _BirthPlaceFieldState extends ConsumerState<BirthPlaceField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chosen = widget.chosen;
    if (chosen != null) {
      return _ChosenPlace(
        place: chosen,
        onClear: () {
          _controller.clear();
          widget.onChosen(null);
        },
      );
    }

    final l10n = AppLocalizations.of(context);
    final index = ref.watch(cityIndexProvider);
    final query = _controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: l10n.profileBirthPlaceLabel,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.sm),
        index.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Text(l10n.profileBirthPlaceLoadFailed),
          data: (cityIndex) {
            final matches = cityIndex.search(
              query,
              limit: BirthPlaceField.maxResults,
            );
            if (matches.isEmpty) {
              return query.trim().length < 2
                  ? const SizedBox.shrink()
                  : Text(l10n.profileBirthPlaceNoMatches);
            }
            return Column(
              children: [
                for (final city in matches)
                  ListTile(
                    minTileHeight: AppSpacing.minTouchTarget,
                    title: Text(city.label),
                    onTap: () => widget.onChosen(city),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ChosenPlace extends ConsumerWidget {
  const _ChosenPlace({required this.place, required this.onClear});

  final BirthPlace place;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final countries = ref.watch(countryNamesProvider).value;
    final label = placeLabel(
      place.name,
      place.region,
      countries?[place.countryCode] ?? place.countryCode,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.profileBirthPlaceChosen(label),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: onClear,
          child: Text(l10n.profileBirthPlaceChange),
        ),
      ],
    );
  }
}
