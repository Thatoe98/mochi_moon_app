import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/onboarding/presentation/birth_place_field.dart';
import 'package:mochi_moon/features/onboarding/presentation/profile_steps.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// Changes the name, birth data and focus areas (PRD §6.13). The chart,
/// readings and compatibility results read the saved profile, so they follow
/// a save without anything being refreshed by hand.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _name = TextEditingController();

  /// What is saved now, and the form's current answers. Both are set once the
  /// profile has loaded.
  UserProfile _saved = const UserProfile();
  UserProfile _draft = const UserProfile();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// Fills the form from the saved profile the first time it is there.
  void _load(UserProfile? profile) {
    if (_loaded) return;
    _loaded = true;
    _saved = profile ?? const UserProfile();
    _draft = _saved;
    _name.text = _saved.displayName;
  }

  void _update(UserProfile draft) => setState(() => _draft = draft);

  void _setCity(City? city) {
    if (city == null) {
      _update(_draft.copyWith(birthPlace: null));
      return;
    }
    final tzId = ref
        .read(timeZoneResolverProvider)
        .resolve(lat: city.lat, lng: city.lng);
    _update(
      _draft.copyWith(
        birthPlace: BirthPlace(
          name: city.name,
          region: city.region,
          countryCode: city.countryCode,
          lat: city.lat,
          lng: city.lng,
          tzId: tzId,
        ),
      ),
    );
  }

  Future<void> _pickDate(DateTime today) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.birthDate ?? DateTime(2000),
      firstDate: DateTime(earliestBirthYear),
      lastDate: DateUtils.dateOnly(today),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) _update(_draft.copyWith(birthDate: picked));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final notifier = ref.read(profileControllerProvider.notifier);
    setState(() => _saving = true);
    try {
      await notifier.save(
        _draft.copyWith(
          displayName: _draft.displayName.trim(),
          birthDate: switch (_draft.birthDate) {
            final date? => DateUtils.dateOnly(date),
            null => null,
          },
        ),
      );
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileEditSaved)));
      if (mounted) router.pop();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaveFailed)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditTitle)),
      body: profile.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(profileControllerProvider)),
        data: (value) {
          _load(value);
          return _form(context);
        },
      ),
    );
  }

  Widget _form(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = ref.watch(clockProvider)();
    final birthDate = _draft.birthDate;
    final minutes = _draft.birthMinutes;
    final changed = _draft != _saved;
    final canSave = changed && _draft.isValidFor(today) && !_saving;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          controller: _name,
          maxLength: maxDisplayNameLength,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n.profileNameLabel),
          onChanged: (value) => _update(_draft.copyWith(displayName: value)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.profileEditBirthDateLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () => _pickDate(today),
          child: Text(
            birthDate == null
                ? l10n.profileEditBirthDateChoose
                : l10n.profileBirthDateChosen(
                    englishDates.formatShortDate(birthDate),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.profileEditBirthTimeLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        BirthTimePicker(
          minutes: minutes,
          onChanged: (value) => _update(_draft.copyWith(birthMinutes: value)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.profileEditBirthPlaceLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        BirthPlaceField(
          chosen: _draft.birthPlace,
          onChosen: _setCity,
          autofocus: false,
        ),
        if (minutes != null && _draft.birthPlace == null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              l10n.profileEditBirthPlaceNeeded,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.profileEditFocusLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        FocusAreaChips(
          selected: _draft.focusAreas,
          onToggle: (area) => _update(
            _draft.copyWith(
              focusAreas: toggleFocusArea(_draft.focusAreas, area),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.profileEditNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: canSave ? _save : null,
          child: Text(l10n.profileEditSave),
        ),
      ],
    );
  }
}
