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
  String get deckIllustrationSemantics => 'A soft moon illustration';

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
}
