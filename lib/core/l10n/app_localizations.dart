import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// App name shown in the app bar and launcher.
  ///
  /// In en, this message translates to:
  /// **'Mochi Moon'**
  String get appName;

  /// No description provided for @tabDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get tabDeck;

  /// No description provided for @tabCosmic.
  ///
  /// In en, this message translates to:
  /// **'Cosmic'**
  String get tabCosmic;

  /// No description provided for @tabMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabMe;

  /// No description provided for @deckTitle.
  ///
  /// In en, this message translates to:
  /// **'Your self-love deck'**
  String get deckTitle;

  /// No description provided for @deckEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Soft little reminders are on their way.'**
  String get deckEmptyBody;

  /// No description provided for @deckStreakSemantics.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day streak} other{{count} day streak}}'**
  String deckStreakSemantics(int count);

  /// No description provided for @deckCardsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card left today} other{{count} cards left today}}'**
  String deckCardsLeft(int count);

  /// No description provided for @deckLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re glowing ✨'**
  String get deckLimitTitle;

  /// No description provided for @deckLimitBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished today\'s cards. Come back tomorrow for more.'**
  String get deckLimitBody;

  /// No description provided for @deckActionSkip.
  ///
  /// In en, this message translates to:
  /// **'Next card'**
  String get deckActionSkip;

  /// No description provided for @deckActionSave.
  ///
  /// In en, this message translates to:
  /// **'This is me'**
  String get deckActionSave;

  /// No description provided for @deckActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get deckActionShare;

  /// No description provided for @deckActionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get deckActionUndo;

  /// No description provided for @deckTimerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Read-aloud timer'**
  String get deckTimerSemantics;

  /// No description provided for @deckTimerReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to swipe'**
  String get deckTimerReady;

  /// No description provided for @deckIllustrationSemantics.
  ///
  /// In en, this message translates to:
  /// **'A soft moon illustration'**
  String get deckIllustrationSemantics;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the share sheet. Please try again.'**
  String get shareFailed;

  /// No description provided for @categorySelfLove.
  ///
  /// In en, this message translates to:
  /// **'Self-love'**
  String get categorySelfLove;

  /// No description provided for @categoryConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get categoryConfidence;

  /// No description provided for @categoryHealing.
  ///
  /// In en, this message translates to:
  /// **'Healing'**
  String get categoryHealing;

  /// No description provided for @categoryStudyWork.
  ///
  /// In en, this message translates to:
  /// **'Study & work'**
  String get categoryStudyWork;

  /// No description provided for @categoryBodyKindness.
  ///
  /// In en, this message translates to:
  /// **'Body kindness'**
  String get categoryBodyKindness;

  /// No description provided for @categoryCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get categoryCalm;

  /// No description provided for @cosmicPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmic you'**
  String get cosmicPlaceholderTitle;

  /// No description provided for @cosmicPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Your stars are warming up.'**
  String get cosmicPlaceholderBody;

  /// No description provided for @mePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Just you'**
  String get mePlaceholderTitle;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your journal'**
  String get journalTitle;

  /// No description provided for @meJournalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cards that feel like you'**
  String get meJournalSubtitle;

  /// No description provided for @journalEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get journalEmptyTitle;

  /// No description provided for @journalEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Swipe right on the cards you love and they\'ll live here.'**
  String get journalEmptyBody;

  /// No description provided for @journalFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get journalFilterAll;

  /// No description provided for @journalRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from your journal?'**
  String get journalRemoveTitle;

  /// No description provided for @journalRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'This card will leave your journal. You can always save it again.'**
  String get journalRemoveBody;

  /// No description provided for @journalRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get journalRemoveConfirm;

  /// No description provided for @journalKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get journalKeep;

  /// No description provided for @journalClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get journalClose;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderTitle;

  /// No description provided for @reminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One gentle card in your notifications'**
  String get reminderSubtitle;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTimeLabel;

  /// No description provided for @reminderPrePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'A gentle daily nudge?'**
  String get reminderPrePromptTitle;

  /// No description provided for @reminderPrePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Mochi Moon can send you one soft card a day at a time you pick. To do that, your phone will ask to allow notifications.'**
  String get reminderPrePromptBody;

  /// No description provided for @reminderPrePromptAllow.
  ///
  /// In en, this message translates to:
  /// **'Sounds good'**
  String get reminderPrePromptAllow;

  /// No description provided for @reminderPrePromptLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get reminderPrePromptLater;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Mochi Moon. You can turn them on in your phone\'s settings.'**
  String get reminderPermissionDenied;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Mochi Moon card ✨'**
  String get reminderNotificationTitle;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'One gentle card each day at the time you choose.'**
  String get reminderChannelDescription;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mochi Moon'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Soft little cards to remind you how wonderful you are. Read each one out loud, then let it sink in.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingTryCards.
  ///
  /// In en, this message translates to:
  /// **'Try {count} cards'**
  String onboardingTryCards(int count);

  /// No description provided for @onboardingCardProgress.
  ///
  /// In en, this message translates to:
  /// **'Card {current} of {total}'**
  String onboardingCardProgress(int current, int total);

  /// No description provided for @onboardingSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your cards and get your cosmic reading'**
  String get onboardingSaveTitle;

  /// No description provided for @onboardingSaveBody.
  ///
  /// In en, this message translates to:
  /// **'The cards you loved are waiting in your journal. Your cosmic reading is on its way.'**
  String get onboardingSaveBody;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @readAloudHint.
  ///
  /// In en, this message translates to:
  /// **'Read it out loud ✨'**
  String get readAloudHint;

  /// No description provided for @entertainmentNote.
  ///
  /// In en, this message translates to:
  /// **'For entertainment and self-reflection'**
  String get entertainmentNote;

  /// No description provided for @stateLoading.
  ///
  /// In en, this message translates to:
  /// **'Gathering a little magic…'**
  String get stateLoading;

  /// No description provided for @stateErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something wobbled'**
  String get stateErrorTitle;

  /// No description provided for @stateErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try that again.'**
  String get stateErrorBody;

  /// No description provided for @stateRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get stateRetry;

  /// No description provided for @stateOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing what we saved for you.'**
  String get stateOffline;

  /// No description provided for @stateEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get stateEmptyTitle;

  /// No description provided for @illustrationOnboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny waving from a glowing crescent moon in a lavender night sky'**
  String get illustrationOnboardingWelcome;

  /// No description provided for @illustrationOnboardingSave.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny hugging a small stack of glowing cards'**
  String get illustrationOnboardingSave;

  /// No description provided for @illustrationEmptyDeck.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny sitting on a sleepy crescent moon, looking at a glowing heart'**
  String get illustrationEmptyDeck;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
