// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mochi Moon';

  @override
  String get tabDeck => 'Deck';

  @override
  String get tabCosmic => 'Cosmic';

  @override
  String get tabMe => 'Me';

  @override
  String get deckTitle => 'Your self-love deck';

  @override
  String get deckEmptyBody => 'Soft little reminders are on their way.';

  @override
  String deckStreakSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String deckCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards left today',
      one: '1 card left today',
    );
    return '$_temp0';
  }

  @override
  String get deckLimitTitle => 'You\'re glowing ✨';

  @override
  String get deckLimitBody =>
      'You\'ve finished today\'s cards. Come back tomorrow for more.';

  @override
  String get deckActionSkip => 'Next card';

  @override
  String get deckActionSave => 'This is me';

  @override
  String get deckActionShare => 'Share';

  @override
  String get deckActionUndo => 'Undo';

  @override
  String get deckTimerSemantics => 'Read-aloud timer';

  @override
  String get deckTimerReady => 'Ready to swipe';

  @override
  String get shareFailed => 'Couldn\'t open the share sheet. Please try again.';

  @override
  String get categorySelfLove => 'Self-love';

  @override
  String get categoryConfidence => 'Confidence';

  @override
  String get categoryHealing => 'Healing';

  @override
  String get categoryStudyWork => 'Study & work';

  @override
  String get categoryBodyKindness => 'Body kindness';

  @override
  String get categoryCalm => 'Calm';

  @override
  String get cosmicPlaceholderTitle => 'Cosmic you';

  @override
  String get cosmicPlaceholderBody => 'Your stars are warming up.';

  @override
  String get mePlaceholderTitle => 'Just you';

  @override
  String get journalTitle => 'Your journal';

  @override
  String get meJournalSubtitle => 'Cards that feel like you';

  @override
  String get journalEmptyTitle => 'Nothing saved yet';

  @override
  String get journalEmptyBody =>
      'Swipe right on the cards you love and they\'ll live here.';

  @override
  String get journalFilterAll => 'All';

  @override
  String get journalRemoveTitle => 'Remove from your journal?';

  @override
  String get journalRemoveBody =>
      'This card will leave your journal. You can always save it again.';

  @override
  String get journalRemoveConfirm => 'Remove';

  @override
  String get journalKeep => 'Keep it';

  @override
  String get journalClose => 'Close';

  @override
  String get reminderTitle => 'Daily reminder';

  @override
  String get reminderSubtitle => 'One gentle card in your notifications';

  @override
  String get reminderTimeLabel => 'Reminder time';

  @override
  String get reminderPrePromptTitle => 'A gentle daily nudge?';

  @override
  String get reminderPrePromptBody =>
      'Mochi Moon can send you one soft card a day at a time you pick. To do that, your phone will ask to allow notifications.';

  @override
  String get reminderPrePromptAllow => 'Sounds good';

  @override
  String get reminderPrePromptLater => 'Not now';

  @override
  String get reminderPermissionDenied =>
      'Notifications are off for Mochi Moon. You can turn them on in your phone\'s settings.';

  @override
  String get reminderNotificationTitle => 'Your Mochi Moon card ✨';

  @override
  String get reminderChannelName => 'Daily reminder';

  @override
  String get reminderChannelDescription =>
      'One gentle card each day at the time you choose.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Mochi Moon';

  @override
  String get onboardingWelcomeBody =>
      'Soft little cards to remind you how wonderful you are. Read each one out loud, then let it sink in.';

  @override
  String onboardingTryCards(int count) {
    return 'Try $count cards';
  }

  @override
  String onboardingCardProgress(int current, int total) {
    return 'Card $current of $total';
  }

  @override
  String get onboardingSaveTitle =>
      'Save your cards and get your cosmic reading';

  @override
  String get onboardingSaveBody =>
      'The cards you loved are waiting in your journal. Your cosmic reading is on its way.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get readAloudHint => 'Read it out loud ✨';

  @override
  String get entertainmentNote => 'For entertainment and self-reflection';

  @override
  String get stateLoading => 'Gathering a little magic…';

  @override
  String get stateErrorTitle => 'Something wobbled';

  @override
  String get stateErrorBody => 'Let\'s try that again.';

  @override
  String get stateRetry => 'Try again';

  @override
  String get stateOffline => 'You\'re offline. Showing what we saved for you.';

  @override
  String get stateEmptyTitle => 'Nothing here yet';

  @override
  String get illustrationOnboardingWelcome =>
      'Mochi the moon bunny waving from a glowing crescent moon in a lavender night sky';

  @override
  String get illustrationOnboardingSave =>
      'Mochi the moon bunny hugging a small stack of glowing cards';

  @override
  String get illustrationEmptyDeck =>
      'Mochi the moon bunny sitting on a sleepy crescent moon, looking at a glowing heart';

  @override
  String get illustrationCalm =>
      'Mochi the moon bunny sitting peacefully with eyes closed among floating petals and stars';

  @override
  String get illustrationConfidence =>
      'Mochi the moon bunny standing proudly with hands on hips on a glowing crescent moon';

  @override
  String get illustrationHealing =>
      'Mochi the moon bunny wrapped in a starry blanket, smiling over a warm cup of tea';

  @override
  String get illustrationSelfWorth =>
      'Mochi the moon bunny holding up a hand mirror that shows a glowing heart';

  @override
  String get illustrationRest =>
      'Mochi the moon bunny sleeping on a soft cloud under a crescent moon';

  @override
  String get signInGoogle => 'Continue with Google';

  @override
  String get signInFailed => 'Couldn\'t sign in. Please try again.';

  @override
  String get signInOffline =>
      'You seem to be offline. Check your connection and try again.';

  @override
  String profileStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get profileBack => 'Back';

  @override
  String get profileNameTitle => 'What should we call you?';

  @override
  String get profileNameBody => 'A first name or a nickname is perfect.';

  @override
  String get profileNameLabel => 'Your name';

  @override
  String get profileBirthDateTitle => 'When is your birthday?';

  @override
  String get profileBirthDateBody =>
      'Your sun sign and your cosmic reading start here.';

  @override
  String profileBirthDateChosen(String date) {
    return 'Born $date';
  }

  @override
  String get profileBirthTimeTitle => 'What time were you born?';

  @override
  String get profileBirthTimeBody =>
      'This is optional. It sharpens your moon and rising signs.';

  @override
  String get profileBirthTimeChoose => 'Choose a time';

  @override
  String get profileBirthTimeChange => 'Change the time';

  @override
  String get profileBirthTimeUnknown => 'I don\'t know';

  @override
  String profileBirthTimeChosen(String time) {
    return 'Born at $time';
  }

  @override
  String get profileBirthTimeNone => 'No birth time. That\'s okay.';

  @override
  String get profileBirthPlaceTitle => 'Where were you born?';

  @override
  String get profileBirthPlaceBodyRequired =>
      'We read your birth time in the time zone of this place.';

  @override
  String get profileBirthPlaceBodyOptional =>
      'This is optional. Search for the nearest city, or skip it.';

  @override
  String get profileBirthPlaceLabel => 'Search for a city';

  @override
  String get profileBirthPlaceNoMatches =>
      'No places found. Try a bigger city nearby.';

  @override
  String get profileBirthPlaceLoadFailed =>
      'The list of places couldn\'t be loaded.';

  @override
  String profileBirthPlaceChosen(String place) {
    return 'Born in $place';
  }

  @override
  String get profileBirthPlaceChange => 'Choose a different place';

  @override
  String get profileReminderTitle => 'A daily nudge?';

  @override
  String get profileReminderBody =>
      'One soft card a day. You can change this any time.';

  @override
  String profileReminderAt(String time) {
    return 'Remind me at $time';
  }

  @override
  String get profileReminderChange => 'Change the time';

  @override
  String get profileReminderOn => 'Remind me';

  @override
  String get profileReminderSkip => 'Skip for now';

  @override
  String get profileFocusTitle => 'What would you like more of?';

  @override
  String profileFocusBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pick up to $count.',
      one: 'Pick up to 1.',
    );
    return '$_temp0';
  }

  @override
  String get profileFinish => 'Let\'s go';

  @override
  String get profileSaveFailed => 'Couldn\'t save that. Please try again.';
}
