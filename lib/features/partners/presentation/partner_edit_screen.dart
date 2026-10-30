import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/onboarding/presentation/birth_place_field.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';
import 'package:mochi_moon/features/partners/domain/partner_draft.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

/// Adds a partner, or edits the one with [partnerId] (PRD §6.12).
class PartnerEditScreen extends ConsumerStatefulWidget {
  const PartnerEditScreen({this.partnerId, super.key});

  final String? partnerId;

  @override
  ConsumerState<PartnerEditScreen> createState() => _PartnerEditScreenState();
}

class _PartnerEditScreenState extends ConsumerState<PartnerEditScreen> {
  final _nickname = TextEditingController();
  PartnerDraft _draft = const PartnerDraft();

  /// Set once a partner being edited has loaded into the form.
  Partner? _editing;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  /// Fills the form from the saved partner the first time the list is there.
  void _load(List<Partner> partners) {
    if (_loaded) return;
    _loaded = true;
    final id = widget.partnerId;
    if (id == null) return;
    for (final partner in partners) {
      if (partner.id == id) {
        _editing = partner;
        _draft = PartnerDraft.of(partner);
        _nickname.text = partner.nickname;
      }
    }
  }

  void _update(PartnerDraft draft) => setState(() => _draft = draft);

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

  Future<void> _pickTime() async {
    final minutes = _draft.birthMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: minutes == null
          ? const TimeOfDay(hour: 12, minute: 0)
          : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) {
      _update(_draft.copyWith(birthMinutes: picked.hour * 60 + picked.minute));
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final notifier = ref.read(partnersProvider.notifier);
    setState(() => _saving = true);
    try {
      final editing = _editing;
      final String id;
      final DateTime createdAt;
      if (editing != null) {
        id = editing.id;
        createdAt = editing.createdAt;
      } else {
        final fresh = notifier.startNew();
        id = fresh.id;
        createdAt = fresh.createdAt;
      }
      await notifier.save(_draft.toPartner(id: id, createdAt: createdAt));
      if (mounted) router.pop();
    } on PartnerLimitReached {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.partnersLimitReached)),
      );
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.partnersSaveFailed)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final partners = ref.watch(partnersProvider);
    final isEdit = widget.partnerId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.partnersEditTitle : l10n.partnersAddTitle),
      ),
      body: partners.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(partnersProvider)),
        data: (items) {
          _load(items);
          if (isEdit && _editing == null) {
            return EmptyState(title: l10n.partnersNotFound);
          }
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
    final time = minutes == null
        ? null
        : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          controller: _nickname,
          maxLength: maxPartnerNicknameLength,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.partnersNicknameLabel,
            helperText: l10n.partnersNicknameHelper,
          ),
          onChanged: (value) => _update(_draft.copyWith(nickname: value)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.partnersBirthDateLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () => _pickDate(today),
          child: Text(
            birthDate == null
                ? l10n.partnersBirthDateChoose
                : l10n.profileBirthDateChosen(
                    englishDates.formatShortDate(birthDate),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.partnersBirthTimeLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: _pickTime,
          child: Text(
            time == null
                ? l10n.profileBirthTimeChoose
                : l10n.profileBirthTimeChosen(
                    englishDates.formatTimeOfDay(time),
                  ),
          ),
        ),
        if (time != null)
          TextButton(
            onPressed: () => _update(_draft.copyWith(birthMinutes: null)),
            child: Text(l10n.profileBirthTimeUnknown),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              l10n.partnersLightHint,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.partnersBirthPlaceLabel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        BirthPlaceField(
          chosen: _draft.birthPlace,
          onChosen: _setCity,
          autofocus: false,
        ),
        if (_draft.missingPlace)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              l10n.partnersBirthPlaceNeeded,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.partnersPrivacy, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: _draft.isValid(today) && !_saving ? _save : null,
          child: Text(l10n.partnersSave),
        ),
      ],
    );
  }
}
