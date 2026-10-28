import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/gated_card_deck.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/application/sign_in_step.dart';
import 'package:mochi_moon/features/onboarding/presentation/onboarding_page.dart';

/// The three sample cards, then the "save your cards" screen (PRD §6.1). The
/// cards use the same timer gate as the daily deck.
class SampleCardsScreen extends ConsumerStatefulWidget {
  const SampleCardsScreen({super.key});

  @override
  ConsumerState<SampleCardsScreen> createState() => _SampleCardsScreenState();
}

class _SampleCardsScreenState extends ConsumerState<SampleCardsScreen> {
  /// Cards whose timer has finished, so an undone card stays unlocked.
  final _read = <String>{};

  Future<void> _onAction(DeckAction action, Quote quote) =>
      ref.read(sampleDeckProvider.notifier).complete(action);

  /// Signs in with Google, then goes on to the profile steps, or straight to
  /// the deck when the account already has a profile. A build without
  /// Firebase config carries on signed out.
  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final outcome = await ref.read(signInStepProvider.notifier).signIn();
    if (!mounted) return;
    switch (outcome) {
      case SignInOutcome.signedIn || SignInOutcome.unavailable:
        context.go(AppRoutes.welcomeProfile);
      case SignInOutcome.restored:
        await ref.read(onboardingCompleteProvider.notifier).complete();
        if (mounted) context.go(AppRoutes.deck);
      case SignInOutcome.cancelled:
        break;
      case SignInOutcome.offline:
        messenger.showSnackBar(SnackBar(content: Text(l10n.signInOffline)));
      case SignInOutcome.failed:
        messenger.showSnackBar(SnackBar(content: Text(l10n.signInFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deck = ref.watch(sampleDeckProvider);
    return Scaffold(
      body: SafeArea(
        child: deck.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () {
              ref
                ..invalidate(quotesProvider)
                ..invalidate(sampleDeckProvider);
            },
          ),
          data: (state) => state.isDone ? _buildPitch() : _buildCards(state),
        ),
      ),
    );
  }

  /// Shown after the last sample card: sign in, then the profile steps.
  Widget _buildPitch() {
    final l10n = AppLocalizations.of(context);
    return OnboardingPage(
      illustration: AppIllustrations.onboardingSave,
      illustrationLabel: l10n.illustrationOnboardingSave,
      title: l10n.onboardingSaveTitle,
      body: l10n.onboardingSaveBody,
      buttonLabel: l10n.signInGoogle,
      busy: ref.watch(signInStepProvider),
      onPressed: _signIn,
    );
  }

  Widget _buildCards(SampleDeckState state) {
    final l10n = AppLocalizations.of(context);
    return GatedCardDeck(
      cards: state.cards,
      position: state.position,
      canUndo: state.canUndo,
      caption: l10n.onboardingCardProgress(
        state.position + 1,
        state.cards.length,
      ),
      readIds: _read,
      onRead: (id) => setState(() => _read.add(id)),
      onAction: _onAction,
      onUndo: ref.read(sampleDeckProvider.notifier).undo,
      allowShare: false,
    );
  }
}
