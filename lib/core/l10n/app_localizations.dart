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

  /// No description provided for @cosmicTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmic you'**
  String get cosmicTitle;

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

  /// No description provided for @illustrationCalm.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny sitting peacefully with eyes closed among floating petals and stars'**
  String get illustrationCalm;

  /// No description provided for @illustrationConfidence.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny standing proudly with hands on hips on a glowing crescent moon'**
  String get illustrationConfidence;

  /// No description provided for @illustrationHealing.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny wrapped in a starry blanket, smiling over a warm cup of tea'**
  String get illustrationHealing;

  /// No description provided for @illustrationSelfWorth.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny holding up a hand mirror that shows a glowing heart'**
  String get illustrationSelfWorth;

  /// No description provided for @illustrationRest.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny sleeping on a soft cloud under a crescent moon'**
  String get illustrationRest;

  /// No description provided for @illustrationZodiac.
  ///
  /// In en, this message translates to:
  /// **'Mochi the moon bunny in a {sign} costume under a glowing {sign} constellation'**
  String illustrationZodiac(String sign);

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInGoogle;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in. Please try again.'**
  String get signInFailed;

  /// No description provided for @signInOffline.
  ///
  /// In en, this message translates to:
  /// **'You seem to be offline. Check your connection and try again.'**
  String get signInOffline;

  /// No description provided for @profileStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String profileStepProgress(int current, int total);

  /// No description provided for @profileBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profileBack;

  /// No description provided for @profileNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get profileNameTitle;

  /// No description provided for @profileNameBody.
  ///
  /// In en, this message translates to:
  /// **'A first name or a nickname is perfect.'**
  String get profileNameBody;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileNameLabel;

  /// No description provided for @profileBirthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'When is your birthday?'**
  String get profileBirthDateTitle;

  /// No description provided for @profileBirthDateBody.
  ///
  /// In en, this message translates to:
  /// **'Your sun sign and your cosmic reading start here.'**
  String get profileBirthDateBody;

  /// No description provided for @profileBirthDateChosen.
  ///
  /// In en, this message translates to:
  /// **'Born {date}'**
  String profileBirthDateChosen(String date);

  /// No description provided for @profileBirthTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'What time were you born?'**
  String get profileBirthTimeTitle;

  /// No description provided for @profileBirthTimeBody.
  ///
  /// In en, this message translates to:
  /// **'This is optional. It sharpens your moon and rising signs.'**
  String get profileBirthTimeBody;

  /// No description provided for @profileBirthTimeChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a time'**
  String get profileBirthTimeChoose;

  /// No description provided for @profileBirthTimeChange.
  ///
  /// In en, this message translates to:
  /// **'Change the time'**
  String get profileBirthTimeChange;

  /// No description provided for @profileBirthTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know'**
  String get profileBirthTimeUnknown;

  /// No description provided for @profileBirthTimeChosen.
  ///
  /// In en, this message translates to:
  /// **'Born at {time}'**
  String profileBirthTimeChosen(String time);

  /// No description provided for @profileBirthTimeNone.
  ///
  /// In en, this message translates to:
  /// **'No birth time. That\'s okay.'**
  String get profileBirthTimeNone;

  /// No description provided for @profileBirthPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Where were you born?'**
  String get profileBirthPlaceTitle;

  /// No description provided for @profileBirthPlaceBodyRequired.
  ///
  /// In en, this message translates to:
  /// **'We read your birth time in the time zone of this place.'**
  String get profileBirthPlaceBodyRequired;

  /// No description provided for @profileBirthPlaceBodyOptional.
  ///
  /// In en, this message translates to:
  /// **'This is optional. Search for the nearest city, or skip it.'**
  String get profileBirthPlaceBodyOptional;

  /// No description provided for @profileBirthPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get profileBirthPlaceLabel;

  /// No description provided for @profileBirthPlaceNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No places found. Try a bigger city nearby.'**
  String get profileBirthPlaceNoMatches;

  /// No description provided for @profileBirthPlaceLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'The list of places couldn\'t be loaded.'**
  String get profileBirthPlaceLoadFailed;

  /// No description provided for @profileBirthPlaceChosen.
  ///
  /// In en, this message translates to:
  /// **'Born in {place}'**
  String profileBirthPlaceChosen(String place);

  /// No description provided for @profileBirthPlaceChange.
  ///
  /// In en, this message translates to:
  /// **'Choose a different place'**
  String get profileBirthPlaceChange;

  /// No description provided for @profileReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'A daily nudge?'**
  String get profileReminderTitle;

  /// No description provided for @profileReminderBody.
  ///
  /// In en, this message translates to:
  /// **'One soft card a day. You can change this any time.'**
  String get profileReminderBody;

  /// No description provided for @profileReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Remind me at {time}'**
  String profileReminderAt(String time);

  /// No description provided for @profileReminderChange.
  ///
  /// In en, this message translates to:
  /// **'Change the time'**
  String get profileReminderChange;

  /// No description provided for @profileReminderOn.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get profileReminderOn;

  /// No description provided for @profileReminderSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get profileReminderSkip;

  /// No description provided for @profileFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like more of?'**
  String get profileFocusTitle;

  /// No description provided for @profileFocusBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Pick up to 1.} other{Pick up to {count}.}}'**
  String profileFocusBody(int count);

  /// No description provided for @profileFinish.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get profileFinish;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save that. Please try again.'**
  String get profileSaveFailed;

  /// No description provided for @cosmicNeedsBirthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Your stars need a date'**
  String get cosmicNeedsBirthDateTitle;

  /// No description provided for @cosmicNeedsBirthDateBody.
  ///
  /// In en, this message translates to:
  /// **'Share your birth date and your daily guidance will appear here.'**
  String get cosmicNeedsBirthDateBody;

  /// No description provided for @cosmicHeader.
  ///
  /// In en, this message translates to:
  /// **'{sign} · {date}'**
  String cosmicHeader(String sign, String date);

  /// No description provided for @cosmicMoonIn.
  ///
  /// In en, this message translates to:
  /// **'Moon in {sign}'**
  String cosmicMoonIn(String sign);

  /// No description provided for @cosmicEnergyTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s energy'**
  String get cosmicEnergyTitle;

  /// No description provided for @cosmicLoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get cosmicLoveTitle;

  /// No description provided for @cosmicLuckyColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lucky colors'**
  String get cosmicLuckyColorsTitle;

  /// No description provided for @cosmicLuckyNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Lucky number'**
  String get cosmicLuckyNumberTitle;

  /// No description provided for @cosmicAvoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Things to avoid'**
  String get cosmicAvoidTitle;

  /// No description provided for @cosmicThaiColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Thai colors'**
  String get cosmicThaiColorsTitle;

  /// No description provided for @cosmicThaiBirthdayColor.
  ///
  /// In en, this message translates to:
  /// **'Your birthday color'**
  String get cosmicThaiBirthdayColor;

  /// No description provided for @cosmicThaiTodayColor.
  ///
  /// In en, this message translates to:
  /// **'Today\'s color'**
  String get cosmicThaiTodayColor;

  /// No description provided for @cosmicDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'For entertainment and self-reflection'**
  String get cosmicDisclaimer;

  /// No description provided for @moonTitle.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moonTitle;

  /// No description provided for @moonPhaseNewMoon.
  ///
  /// In en, this message translates to:
  /// **'New moon'**
  String get moonPhaseNewMoon;

  /// No description provided for @moonPhaseWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing crescent'**
  String get moonPhaseWaxingCrescent;

  /// No description provided for @moonPhaseFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First quarter'**
  String get moonPhaseFirstQuarter;

  /// No description provided for @moonPhaseWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing gibbous'**
  String get moonPhaseWaxingGibbous;

  /// No description provided for @moonPhaseFullMoon.
  ///
  /// In en, this message translates to:
  /// **'Full moon'**
  String get moonPhaseFullMoon;

  /// No description provided for @moonPhaseWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning gibbous'**
  String get moonPhaseWaningGibbous;

  /// No description provided for @moonPhaseLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last quarter'**
  String get moonPhaseLastQuarter;

  /// No description provided for @moonPhaseWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning crescent'**
  String get moonPhaseWaningCrescent;

  /// No description provided for @moonIlluminated.
  ///
  /// In en, this message translates to:
  /// **'{percent}% lit'**
  String moonIlluminated(int percent);

  /// No description provided for @moonNextNew.
  ///
  /// In en, this message translates to:
  /// **'Next new moon: {date}'**
  String moonNextNew(String date);

  /// No description provided for @moonNextFull.
  ///
  /// In en, this message translates to:
  /// **'Next full moon: {date}'**
  String moonNextFull(String date);

  /// No description provided for @moonAffirmationNewMoon.
  ///
  /// In en, this message translates to:
  /// **'I plant a gentle intention for myself, and I trust it to grow.'**
  String get moonAffirmationNewMoon;

  /// No description provided for @moonAffirmationWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'I take one small, kind step toward what I want.'**
  String get moonAffirmationWaxingCrescent;

  /// No description provided for @moonAffirmationFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'I can keep going at my own pace, and my effort matters.'**
  String get moonAffirmationFirstQuarter;

  /// No description provided for @moonAffirmationWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'I trust what I have started and I give it time to bloom.'**
  String get moonAffirmationWaxingGibbous;

  /// No description provided for @moonAffirmationFullMoon.
  ///
  /// In en, this message translates to:
  /// **'I am glowing, and I am grateful for how far I have come.'**
  String get moonAffirmationFullMoon;

  /// No description provided for @moonAffirmationWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'I share what I have learned and I thank myself for it.'**
  String get moonAffirmationWaningGibbous;

  /// No description provided for @moonAffirmationLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'I let go of what feels heavy, and I forgive myself with ease.'**
  String get moonAffirmationLastQuarter;

  /// No description provided for @moonAffirmationWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'I rest, I soften, and I make room for a fresh start.'**
  String get moonAffirmationWaningCrescent;

  /// No description provided for @reduceMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get reduceMotionTitle;

  /// No description provided for @reduceMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calmer cards: no tilting or sparkles. Already on if your phone removes animations'**
  String get reduceMotionSubtitle;

  /// No description provided for @thaiColorsSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Thai day colors'**
  String get thaiColorsSettingTitle;

  /// No description provided for @thaiColorsSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show your birthday color and today\'s color on Cosmic you'**
  String get thaiColorsSettingSubtitle;

  /// Settings row and sheet title for choosing the app language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Language option that follows the device language
  ///
  /// In en, this message translates to:
  /// **'Same as my phone'**
  String get languageSystem;

  /// No description provided for @signAries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get signAries;

  /// No description provided for @signTaurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get signTaurus;

  /// No description provided for @signGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get signGemini;

  /// No description provided for @signCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get signCancer;

  /// No description provided for @signLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get signLeo;

  /// No description provided for @signVirgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get signVirgo;

  /// No description provided for @signLibra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get signLibra;

  /// No description provided for @signScorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get signScorpio;

  /// No description provided for @signSagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get signSagittarius;

  /// No description provided for @signCapricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get signCapricorn;

  /// No description provided for @signAquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get signAquarius;

  /// No description provided for @signPisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get signPisces;

  /// No description provided for @retroTitle.
  ///
  /// In en, this message translates to:
  /// **'Retrogrades'**
  String get retroTitle;

  /// No description provided for @retroMercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get retroMercury;

  /// No description provided for @retroVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get retroVenus;

  /// No description provided for @retroMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get retroMars;

  /// No description provided for @retroJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get retroJupiter;

  /// No description provided for @retroSaturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get retroSaturn;

  /// No description provided for @retroStatusRetrograde.
  ///
  /// In en, this message translates to:
  /// **'{planet} is retrograde until {date}'**
  String retroStatusRetrograde(String planet, String date);

  /// No description provided for @retroStatusNext.
  ///
  /// In en, this message translates to:
  /// **'Next {planet} retrograde: {date}'**
  String retroStatusNext(String planet, String date);

  /// No description provided for @retroStartsToday.
  ///
  /// In en, this message translates to:
  /// **'Starts today'**
  String get retroStartsToday;

  /// No description provided for @retroStartsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Starts tomorrow'**
  String get retroStartsTomorrow;

  /// No description provided for @retroStartsInDays.
  ///
  /// In en, this message translates to:
  /// **'Starts in {days} days'**
  String retroStartsInDays(int days);

  /// No description provided for @retroCardHint.
  ///
  /// In en, this message translates to:
  /// **'See all retrogrades'**
  String get retroCardHint;

  /// No description provided for @retroTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle tips'**
  String get retroTipsTitle;

  /// No description provided for @retroTipMercury.
  ///
  /// In en, this message translates to:
  /// **'A lovely time to revisit, rest and re-read. Double-check your plans, save your photos, and give messages a little extra time.'**
  String get retroTipMercury;

  /// No description provided for @retroTipVenus.
  ///
  /// In en, this message translates to:
  /// **'A tender season to reflect on what you value in love and friendship. Notice what feels true before starting something new.'**
  String get retroTipVenus;

  /// No description provided for @retroTipMars.
  ///
  /// In en, this message translates to:
  /// **'Your energy may feel slower. Choose rest over rushing, and let small, steady steps count.'**
  String get retroTipMars;

  /// No description provided for @retroTipJupiter.
  ///
  /// In en, this message translates to:
  /// **'A slower season for growth. Savor what you have learned and let your dreams take shape at their own pace.'**
  String get retroTipJupiter;

  /// No description provided for @retroTipSaturn.
  ///
  /// In en, this message translates to:
  /// **'A quiet time to review your routines and boundaries, with kindness toward yourself.'**
  String get retroTipSaturn;

  /// No description provided for @retroNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get retroNowTitle;

  /// No description provided for @retroCalmTitle.
  ///
  /// In en, this message translates to:
  /// **'All planets are moving forward'**
  String get retroCalmTitle;

  /// No description provided for @retroCalmBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing is retrograde at the moment, so enjoy the smooth flow.'**
  String get retroCalmBody;

  /// No description provided for @retroTipMercury1.
  ///
  /// In en, this message translates to:
  /// **'Back up your photos and re-read messages before you send them.'**
  String get retroTipMercury1;

  /// No description provided for @retroTipMercury2.
  ///
  /// In en, this message translates to:
  /// **'Leave a little extra time for plans and trips.'**
  String get retroTipMercury2;

  /// No description provided for @retroTipMercury3.
  ///
  /// In en, this message translates to:
  /// **'Reconnect softly with someone or something you have missed.'**
  String get retroTipMercury3;

  /// No description provided for @retroTipVenus1.
  ///
  /// In en, this message translates to:
  /// **'Take your time before big choices about love or style.'**
  String get retroTipVenus1;

  /// No description provided for @retroTipVenus2.
  ///
  /// In en, this message translates to:
  /// **'Do something that makes you feel lovely, just because.'**
  String get retroTipVenus2;

  /// No description provided for @retroTipVenus3.
  ///
  /// In en, this message translates to:
  /// **'Notice who feels easy and warm to be around.'**
  String get retroTipVenus3;

  /// No description provided for @retroTipMars1.
  ///
  /// In en, this message translates to:
  /// **'Choose gentle movement over pushing hard.'**
  String get retroTipMars1;

  /// No description provided for @retroTipMars2.
  ///
  /// In en, this message translates to:
  /// **'Pick one small task and let that be enough today.'**
  String get retroTipMars2;

  /// No description provided for @retroTipMars3.
  ///
  /// In en, this message translates to:
  /// **'Pause and breathe before reacting when you feel frustrated.'**
  String get retroTipMars3;

  /// No description provided for @retroTipJupiter1.
  ///
  /// In en, this message translates to:
  /// **'Celebrate how far you have already come.'**
  String get retroTipJupiter1;

  /// No description provided for @retroTipJupiter2.
  ///
  /// In en, this message translates to:
  /// **'Return to a dream and let it grow slowly.'**
  String get retroTipJupiter2;

  /// No description provided for @retroTipJupiter3.
  ///
  /// In en, this message translates to:
  /// **'Stay curious about what you have been learning.'**
  String get retroTipJupiter3;

  /// No description provided for @retroTipSaturn1.
  ///
  /// In en, this message translates to:
  /// **'Tidy one routine that no longer fits you.'**
  String get retroTipSaturn1;

  /// No description provided for @retroTipSaturn2.
  ///
  /// In en, this message translates to:
  /// **'Notice a boundary you would like to honor, and honor it kindly.'**
  String get retroTipSaturn2;

  /// No description provided for @retroTipSaturn3.
  ///
  /// In en, this message translates to:
  /// **'Thank yourself for your steady effort.'**
  String get retroTipSaturn3;

  /// No description provided for @retroCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Retrograde calendar'**
  String get retroCalendarTitle;

  /// No description provided for @retroCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Colored days show when a planet is retrograde.'**
  String get retroCalendarSubtitle;

  /// No description provided for @retroCalendarPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get retroCalendarPrevious;

  /// No description provided for @retroCalendarNext.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get retroCalendarNext;

  /// No description provided for @retroCalendarDay.
  ///
  /// In en, this message translates to:
  /// **'{date}: {planets} retrograde'**
  String retroCalendarDay(String date, String planets);

  /// No description provided for @retroAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Retrograde heads-ups'**
  String get retroAlertsTitle;

  /// No description provided for @retroAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A gentle note the day before and the day a planet turns'**
  String get retroAlertsSubtitle;

  /// No description provided for @retroAlertsPrePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'A soft cosmic heads-up?'**
  String get retroAlertsPrePromptTitle;

  /// No description provided for @retroAlertsPrePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Mochi Moon can send a gentle note the day before and the day a planet turns retrograde or direct. To do that, your phone will ask to allow notifications.'**
  String get retroAlertsPrePromptBody;

  /// No description provided for @retroAlertNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmic heads-up 🌙'**
  String get retroAlertNotificationTitle;

  /// No description provided for @retroAlertChannelName.
  ///
  /// In en, this message translates to:
  /// **'Retrograde heads-ups'**
  String get retroAlertChannelName;

  /// No description provided for @retroAlertChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'A gentle note around the days a planet turns retrograde or direct.'**
  String get retroAlertChannelDescription;

  /// No description provided for @retroAlertStartsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'{planet} turns retrograde tomorrow. A lovely moment to slow down and be kind to yourself.'**
  String retroAlertStartsTomorrow(String planet);

  /// No description provided for @retroAlertStartsToday.
  ///
  /// In en, this message translates to:
  /// **'{planet} turns retrograde today. Take it softly and trust your own pace.'**
  String retroAlertStartsToday(String planet);

  /// No description provided for @retroAlertEndsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'{planet} turns direct tomorrow. Things start to flow forward again.'**
  String retroAlertEndsTomorrow(String planet);

  /// No description provided for @retroAlertEndsToday.
  ///
  /// In en, this message translates to:
  /// **'{planet} turns direct today. Welcome the fresh, steady momentum.'**
  String retroAlertEndsToday(String planet);

  /// No description provided for @accountDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get accountDeleteTitle;

  /// No description provided for @accountDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Erase your profile, saved cards and progress, and start over'**
  String get accountDeleteSubtitle;

  /// No description provided for @accountDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get accountDeleteConfirmTitle;

  /// No description provided for @accountDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently erases your profile, saved cards, progress and sign-in, both on this phone and from Mochi Moon. It cannot be undone.'**
  String get accountDeleteConfirmBody;

  /// No description provided for @accountDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get accountDeleteConfirmAction;

  /// No description provided for @accountDeleteKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get accountDeleteKeep;

  /// No description provided for @accountDeleteDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account...'**
  String get accountDeleteDeleting;

  /// No description provided for @accountDeleteOffline.
  ///
  /// In en, this message translates to:
  /// **'You seem to be offline. Please connect and try again.'**
  String get accountDeleteOffline;

  /// No description provided for @accountDeleteFinalTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you completely sure?'**
  String get accountDeleteFinalTitle;

  /// No description provided for @accountDeleteFinalBody.
  ///
  /// In en, this message translates to:
  /// **'This is your last chance. Everything will be erased for good and Mochi Moon will start over as if you had just installed it.'**
  String get accountDeleteFinalBody;

  /// No description provided for @accountDeleteFinalAction.
  ///
  /// In en, this message translates to:
  /// **'Yes, erase everything'**
  String get accountDeleteFinalAction;

  /// No description provided for @cosmicSignPickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a sign to read'**
  String get cosmicSignPickerLabel;

  /// No description provided for @cosmicSignPickerYou.
  ///
  /// In en, this message translates to:
  /// **'{sign} (you)'**
  String cosmicSignPickerYou(String sign);

  /// No description provided for @accountDeleteCancelled.
  ///
  /// In en, this message translates to:
  /// **'Nothing was deleted. You are still signed in.'**
  String get accountDeleteCancelled;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong and nothing was deleted. Please try again.'**
  String get accountDeleteFailed;

  /// No description provided for @chartTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth chart'**
  String get chartTitle;

  /// No description provided for @chartButtonHint.
  ///
  /// In en, this message translates to:
  /// **'See your Sun, Moon and Rising'**
  String get chartButtonHint;

  /// No description provided for @chartBigThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Big 3'**
  String get chartBigThreeTitle;

  /// No description provided for @chartPlacementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Placements'**
  String get chartPlacementsTitle;

  /// No description provided for @chartWheelLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth chart wheel. The placements are listed below.'**
  String get chartWheelLabel;

  /// No description provided for @chartBodySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get chartBodySun;

  /// No description provided for @chartBodyMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get chartBodyMoon;

  /// No description provided for @chartBodyMercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get chartBodyMercury;

  /// No description provided for @chartBodyVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get chartBodyVenus;

  /// No description provided for @chartBodyMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get chartBodyMars;

  /// No description provided for @chartBodyJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get chartBodyJupiter;

  /// No description provided for @chartBodySaturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get chartBodySaturn;

  /// No description provided for @chartBodyUranus.
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get chartBodyUranus;

  /// No description provided for @chartBodyNeptune.
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get chartBodyNeptune;

  /// No description provided for @chartBodyPluto.
  ///
  /// In en, this message translates to:
  /// **'Pluto'**
  String get chartBodyPluto;

  /// No description provided for @chartBodyRising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get chartBodyRising;

  /// No description provided for @chartBodyAscendant.
  ///
  /// In en, this message translates to:
  /// **'Ascendant'**
  String get chartBodyAscendant;

  /// No description provided for @chartBodyMidheaven.
  ///
  /// In en, this message translates to:
  /// **'Midheaven'**
  String get chartBodyMidheaven;

  /// No description provided for @chartRoleIn.
  ///
  /// In en, this message translates to:
  /// **'{role} in {sign}'**
  String chartRoleIn(String role, String sign);

  /// No description provided for @chartHouse.
  ///
  /// In en, this message translates to:
  /// **'House {number}'**
  String chartHouse(int number);

  /// No description provided for @chartRetrograde.
  ///
  /// In en, this message translates to:
  /// **'retrograde'**
  String get chartRetrograde;

  /// No description provided for @chartApproximate.
  ///
  /// In en, this message translates to:
  /// **'approximate'**
  String get chartApproximate;

  /// No description provided for @chartRowLabel.
  ///
  /// In en, this message translates to:
  /// **'{body} in {sign}, {degrees}'**
  String chartRowLabel(String body, String sign, String degrees);

  /// No description provided for @chartNoTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your birth time'**
  String get chartNoTimeTitle;

  /// No description provided for @chartNoTimeBody.
  ///
  /// In en, this message translates to:
  /// **'Without it we can\'t find your Rising sign or your houses, and your Moon sign is only approximate.'**
  String get chartNoTimeBody;

  /// No description provided for @chartNeedsBirthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Your chart needs a birth date'**
  String get chartNeedsBirthDateTitle;

  /// No description provided for @chartNeedsBirthDateBody.
  ///
  /// In en, this message translates to:
  /// **'Add your birth date to see your Sun, Moon and Rising.'**
  String get chartNeedsBirthDateBody;

  /// No description provided for @chartHighLatitudeNote.
  ///
  /// In en, this message translates to:
  /// **'Near the poles the Rising sign can be less reliable.'**
  String get chartHighLatitudeNote;

  /// No description provided for @chartSunAries.
  ///
  /// In en, this message translates to:
  /// **'You have a brave, bright spark. You shine when you start something new, and your courage can be gentle too.'**
  String get chartSunAries;

  /// No description provided for @chartSunTaurus.
  ///
  /// In en, this message translates to:
  /// **'You are steady, warm and loyal. You glow when life feels cozy, and slow, patient steps are a strength.'**
  String get chartSunTaurus;

  /// No description provided for @chartSunGemini.
  ///
  /// In en, this message translates to:
  /// **'You are curious, playful and quick with words. Your many sides are not a flaw, they are your charm.'**
  String get chartSunGemini;

  /// No description provided for @chartSunCancer.
  ///
  /// In en, this message translates to:
  /// **'You feel deeply and care for others with a soft heart. Your sensitivity is a gift, and you deserve the same tenderness.'**
  String get chartSunCancer;

  /// No description provided for @chartSunLeo.
  ///
  /// In en, this message translates to:
  /// **'You carry a warm, sunny presence. You love to shine and to cheer others on, and you are enough even on quiet days.'**
  String get chartSunLeo;

  /// No description provided for @chartSunVirgo.
  ///
  /// In en, this message translates to:
  /// **'You are thoughtful, caring and good with details. You are allowed to be kind to yourself, even when things are not perfect.'**
  String get chartSunVirgo;

  /// No description provided for @chartSunLibra.
  ///
  /// In en, this message translates to:
  /// **'You bring balance, beauty and gentle harmony wherever you go. Your own needs matter as much as everyone else\'s.'**
  String get chartSunLibra;

  /// No description provided for @chartSunScorpio.
  ///
  /// In en, this message translates to:
  /// **'You feel things with depth and you are loyal to the core. Your intensity is a strength, and you can soften when you are ready.'**
  String get chartSunScorpio;

  /// No description provided for @chartSunSagittarius.
  ///
  /// In en, this message translates to:
  /// **'You are adventurous, honest and full of hope. You grow whenever you follow your curiosity.'**
  String get chartSunSagittarius;

  /// No description provided for @chartSunCapricorn.
  ///
  /// In en, this message translates to:
  /// **'You are patient, determined and dependable. You can rest and still be proud of how far you have come.'**
  String get chartSunCapricorn;

  /// No description provided for @chartSunAquarius.
  ///
  /// In en, this message translates to:
  /// **'You are original, kind and a little bit dreamy. Your different way of seeing things is what makes you special.'**
  String get chartSunAquarius;

  /// No description provided for @chartSunPisces.
  ///
  /// In en, this message translates to:
  /// **'You are gentle, imaginative and full of compassion. Your dreams are worth protecting, and so is your peace.'**
  String get chartSunPisces;

  /// No description provided for @chartMoonAries.
  ///
  /// In en, this message translates to:
  /// **'Your feelings arrive fast and bright. Give yourself a moment to breathe, and let your heart move at its own pace.'**
  String get chartMoonAries;

  /// No description provided for @chartMoonTaurus.
  ///
  /// In en, this message translates to:
  /// **'You feel safest with comfort and calm. Cozy routines, good food and soft things help your heart settle.'**
  String get chartMoonTaurus;

  /// No description provided for @chartMoonGemini.
  ///
  /// In en, this message translates to:
  /// **'Talking, writing or sharing helps you understand how you feel. It is okay if your moods change like the sky.'**
  String get chartMoonGemini;

  /// No description provided for @chartMoonCancer.
  ///
  /// In en, this message translates to:
  /// **'You feel everything deeply, and home is where your heart rests. Be as gentle with yourself as you are with others.'**
  String get chartMoonCancer;

  /// No description provided for @chartMoonLeo.
  ///
  /// In en, this message translates to:
  /// **'Your heart loves to be seen and appreciated. Kind words, from others and from you, help you glow.'**
  String get chartMoonLeo;

  /// No description provided for @chartMoonVirgo.
  ///
  /// In en, this message translates to:
  /// **'You feel calm when things are tidy and useful. You can let small worries go, because you are doing well.'**
  String get chartMoonVirgo;

  /// No description provided for @chartMoonLibra.
  ///
  /// In en, this message translates to:
  /// **'You feel best when things are peaceful and fair. It is okay to say what you need, even when it feels hard.'**
  String get chartMoonLibra;

  /// No description provided for @chartMoonScorpio.
  ///
  /// In en, this message translates to:
  /// **'Your feelings run deep and private. You can take your time before opening up, and trust those who have earned it.'**
  String get chartMoonScorpio;

  /// No description provided for @chartMoonSagittarius.
  ///
  /// In en, this message translates to:
  /// **'You feel free when you have space and hope. A walk, a laugh or a little adventure lifts your mood.'**
  String get chartMoonSagittarius;

  /// No description provided for @chartMoonCapricorn.
  ///
  /// In en, this message translates to:
  /// **'You may keep your feelings close and tend to them quietly. Soft rest is just as important as hard work.'**
  String get chartMoonCapricorn;

  /// No description provided for @chartMoonAquarius.
  ///
  /// In en, this message translates to:
  /// **'You make sense of feelings by stepping back and thinking them through. Your heart is warm even when it is quiet.'**
  String get chartMoonAquarius;

  /// No description provided for @chartMoonPisces.
  ///
  /// In en, this message translates to:
  /// **'Your heart is soft and picks up on every mood around you. Quiet time, music and dreaming help you recharge.'**
  String get chartMoonPisces;

  /// No description provided for @chartRisingAries.
  ///
  /// In en, this message translates to:
  /// **'People may see you as bold, energetic and ready to go. Your confidence invites others to be brave too.'**
  String get chartRisingAries;

  /// No description provided for @chartRisingTaurus.
  ///
  /// In en, this message translates to:
  /// **'People may see you as calm, grounded and warm. Your steady presence makes others feel at ease.'**
  String get chartRisingTaurus;

  /// No description provided for @chartRisingGemini.
  ///
  /// In en, this message translates to:
  /// **'People may see you as bright, curious and easy to talk to. Your lively energy is a joy to be around.'**
  String get chartRisingGemini;

  /// No description provided for @chartRisingCancer.
  ///
  /// In en, this message translates to:
  /// **'People may see you as gentle and caring. Your kindness makes others feel at home.'**
  String get chartRisingCancer;

  /// No description provided for @chartRisingLeo.
  ///
  /// In en, this message translates to:
  /// **'People may see you as warm, confident and a little bit sparkly. Your presence lights up a room.'**
  String get chartRisingLeo;

  /// No description provided for @chartRisingVirgo.
  ///
  /// In en, this message translates to:
  /// **'People may see you as thoughtful, neat and kind. Your quiet care shows in the little things.'**
  String get chartRisingVirgo;

  /// No description provided for @chartRisingLibra.
  ///
  /// In en, this message translates to:
  /// **'People may see you as graceful, friendly and easygoing. Your charm helps others feel welcome.'**
  String get chartRisingLibra;

  /// No description provided for @chartRisingScorpio.
  ///
  /// In en, this message translates to:
  /// **'People may see you as calm, magnetic and a little mysterious. Your depth makes others curious.'**
  String get chartRisingScorpio;

  /// No description provided for @chartRisingSagittarius.
  ///
  /// In en, this message translates to:
  /// **'People may see you as cheerful, open and adventurous. Your optimism is contagious.'**
  String get chartRisingSagittarius;

  /// No description provided for @chartRisingCapricorn.
  ///
  /// In en, this message translates to:
  /// **'People may see you as composed, capable and wise. Your calm focus earns trust.'**
  String get chartRisingCapricorn;

  /// No description provided for @chartRisingAquarius.
  ///
  /// In en, this message translates to:
  /// **'People may see you as unique, friendly and a bit unexpected. Your originality stands out in a lovely way.'**
  String get chartRisingAquarius;

  /// No description provided for @chartRisingPisces.
  ///
  /// In en, this message translates to:
  /// **'People may see you as soft, dreamy and kind. Your gentle aura makes others feel understood.'**
  String get chartRisingPisces;

  /// No description provided for @mePartnersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'People you compare your chart with'**
  String get mePartnersSubtitle;

  /// No description provided for @partnersTitle.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get partnersTitle;

  /// No description provided for @partnersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No partners yet'**
  String get partnersEmptyTitle;

  /// No description provided for @partnersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add someone\'s birthday to see how your charts get along. It\'s just for fun and self-reflection.'**
  String get partnersEmptyBody;

  /// No description provided for @partnersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a partner'**
  String get partnersAdd;

  /// No description provided for @partnersLimitFree.
  ///
  /// In en, this message translates to:
  /// **'Free includes {free} partner. Premium keeps up to {premium}.'**
  String partnersLimitFree(int free, int premium);

  /// No description provided for @partnersLimitPremium.
  ///
  /// In en, this message translates to:
  /// **'You\'ve saved the most partners you can ({count}). Delete one to add someone new.'**
  String partnersLimitPremium(int count);

  /// No description provided for @partnersTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{sign} · Born {date}'**
  String partnersTileSubtitle(String sign, String date);

  /// No description provided for @partnersDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String partnersDeleteTooltip(String name);

  /// No description provided for @partnersDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String partnersDeleteTitle(String name);

  /// No description provided for @partnersDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Their birth details will be removed from this phone and from your account. You can add them again anytime.'**
  String get partnersDeleteBody;

  /// No description provided for @partnersDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get partnersDeleteConfirm;

  /// No description provided for @partnersAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a partner'**
  String get partnersAddTitle;

  /// No description provided for @partnersEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit partner'**
  String get partnersEditTitle;

  /// No description provided for @partnersNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get partnersNicknameLabel;

  /// No description provided for @partnersNicknameHelper.
  ///
  /// In en, this message translates to:
  /// **'A nickname is perfect. Only you can see it.'**
  String get partnersNicknameHelper;

  /// No description provided for @partnersBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get partnersBirthDateLabel;

  /// No description provided for @partnersBirthDateChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get partnersBirthDateChoose;

  /// No description provided for @partnersBirthTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth time (optional)'**
  String get partnersBirthTimeLabel;

  /// No description provided for @partnersBirthPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthplace (optional)'**
  String get partnersBirthPlaceLabel;

  /// No description provided for @partnersBirthPlaceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Add a birthplace so we can read the birth time in the right time zone.'**
  String get partnersBirthPlaceNeeded;

  /// No description provided for @partnersLightHint.
  ///
  /// In en, this message translates to:
  /// **'Without a birth time you\'ll get a light reading, which is still lovely.'**
  String get partnersLightHint;

  /// No description provided for @partnersPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only you can see this, and you can delete it anytime.'**
  String get partnersPrivacy;

  /// No description provided for @partnersSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get partnersSave;

  /// No description provided for @partnersSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save this. Please try again.'**
  String get partnersSaveFailed;

  /// No description provided for @partnersLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the partner limit.'**
  String get partnersLimitReached;

  /// No description provided for @partnersNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this partner.'**
  String get partnersNotFound;

  /// No description provided for @partnersEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String partnersEditTooltip(String name);

  /// No description provided for @compatTitle.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get compatTitle;

  /// No description provided for @compatNeedsBirthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your birthday to compare'**
  String get compatNeedsBirthDateTitle;

  /// No description provided for @compatNeedsBirthDateBody.
  ///
  /// In en, this message translates to:
  /// **'Your own birth date is needed to read how your chart and theirs meet.'**
  String get compatNeedsBirthDateBody;

  /// No description provided for @compatHeader.
  ///
  /// In en, this message translates to:
  /// **'You ({yourSign}) + {name} ({theirSign})'**
  String compatHeader(String yourSign, String name, String theirSign);

  /// No description provided for @compatMeterLabel.
  ///
  /// In en, this message translates to:
  /// **'Compatibility {score} percent'**
  String compatMeterLabel(int score);

  /// No description provided for @compatSummaryLow.
  ///
  /// In en, this message translates to:
  /// **'A gentle pairing with plenty of room to grow together.'**
  String get compatSummaryLow;

  /// No description provided for @compatSummaryMid.
  ///
  /// In en, this message translates to:
  /// **'A warm pairing with lovely moments of ease.'**
  String get compatSummaryMid;

  /// No description provided for @compatSummaryHigh.
  ///
  /// In en, this message translates to:
  /// **'A bright pairing where your charts really sing together.'**
  String get compatSummaryHigh;

  /// No description provided for @compatLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light reading'**
  String get compatLightLabel;

  /// No description provided for @compatLightBody.
  ///
  /// In en, this message translates to:
  /// **'Without both birth times this is a lighter reading. Adding a birth time and place makes it richer.'**
  String get compatLightBody;

  /// No description provided for @compatThemeRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get compatThemeRomance;

  /// No description provided for @compatThemeEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get compatThemeEmotional;

  /// No description provided for @compatThemeCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get compatThemeCommunication;

  /// No description provided for @compatThemeScore.
  ///
  /// In en, this message translates to:
  /// **'{theme} {score} percent'**
  String compatThemeScore(String theme, int score);

  /// No description provided for @compatFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'What flows'**
  String get compatFlowTitle;

  /// No description provided for @compatGrowTitle.
  ///
  /// In en, this message translates to:
  /// **'Where you grow'**
  String get compatGrowTitle;

  /// No description provided for @compatQuiet.
  ///
  /// In en, this message translates to:
  /// **'Your charts are quiet together, and that\'s okay. Every connection finds its own rhythm.'**
  String get compatQuiet;

  /// No description provided for @compatAspectPair.
  ///
  /// In en, this message translates to:
  /// **'Your {yours} + {name}\'s {theirs}'**
  String compatAspectPair(String yours, String name, String theirs);

  /// No description provided for @compatAspectConjunction.
  ///
  /// In en, this message translates to:
  /// **'These two blend together, so this part of you feels naturally close.'**
  String get compatAspectConjunction;

  /// No description provided for @compatAspectSextile.
  ///
  /// In en, this message translates to:
  /// **'These two cooperate easily, with a friendly give and take.'**
  String get compatAspectSextile;

  /// No description provided for @compatAspectTrine.
  ///
  /// In en, this message translates to:
  /// **'These two flow together with an effortless, easy warmth.'**
  String get compatAspectTrine;

  /// No description provided for @compatAspectSquare.
  ///
  /// In en, this message translates to:
  /// **'These two have a spark that asks for patience and understanding.'**
  String get compatAspectSquare;

  /// No description provided for @compatAspectOpposition.
  ///
  /// In en, this message translates to:
  /// **'These two pull in different directions, so balance and listening help here.'**
  String get compatAspectOpposition;

  /// No description provided for @meProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get meProfileTitle;

  /// No description provided for @meProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your name, birthday and focus areas'**
  String get meProfileSubtitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get profileEditBirthDateLabel;

  /// No description provided for @profileEditBirthDateChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get profileEditBirthDateChoose;

  /// No description provided for @profileEditBirthTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth time (optional)'**
  String get profileEditBirthTimeLabel;

  /// No description provided for @profileEditBirthPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthplace'**
  String get profileEditBirthPlaceLabel;

  /// No description provided for @profileEditBirthPlaceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Add a birthplace so we can read the birth time in the right time zone.'**
  String get profileEditBirthPlaceNeeded;

  /// No description provided for @profileEditFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'What you\'d like more of'**
  String get profileEditFocusLabel;

  /// No description provided for @profileEditNote.
  ///
  /// In en, this message translates to:
  /// **'Changing your birth details updates your birth chart, your readings and your compatibility results.'**
  String get profileEditNote;

  /// No description provided for @profileEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSave;

  /// No description provided for @profileEditSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileEditSaved;
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
