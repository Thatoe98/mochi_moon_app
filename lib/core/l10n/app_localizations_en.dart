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
  String get tabToday => 'Today';

  @override
  String get tabDeck => 'Deck';

  @override
  String get tabCosmic => 'Cosmic';

  @override
  String get tabMe => 'Me';

  @override
  String get todayTitle => 'Today';

  @override
  String todayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days of self-love',
      one: '1 day of self-love',
    );
    return '$_temp0';
  }

  @override
  String get todayNoStreak => 'Start your self-love streak today';

  @override
  String get todayBody =>
      'Two soft minutes with Mochi. Read a few kind cards, and let them sink in.';

  @override
  String get todayStart => 'Read today\'s cards';

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
  String get deckLimitPremiumNote =>
      'Premium keeps the deck open all day, whenever you want more.';

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
  String get cosmicTitle => 'Cosmic you';

  @override
  String get mePlaceholderTitle => 'Just you';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodTired => 'Tired';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodAnxious => 'Anxious';

  @override
  String get moodInLove => 'In love';

  @override
  String get moodCheckInTitle => 'How are you feeling today?';

  @override
  String get moodScreenTitle => 'Your moods';

  @override
  String get moodMeSubtitle => 'Check in and see your month';

  @override
  String get moodPreviousMonth => 'Previous month';

  @override
  String moodHistoryLocked(String month) {
    return 'Mood calendar for $month';
  }

  @override
  String get moodNextMonth => 'Next month';

  @override
  String get moodDayNone => 'No mood saved for this day.';

  @override
  String moodDayValue(String date, String mood) {
    return '$date: $mood';
  }

  @override
  String moodDaySemanticsNone(String date) {
    return '$date, no mood';
  }

  @override
  String moodDaySemantics(String date, String mood) {
    return '$date, $mood';
  }

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
  String illustrationZodiac(String sign) {
    return 'Mochi the moon bunny in a $sign costume under a glowing $sign constellation';
  }

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

  @override
  String get cosmicNeedsBirthDateTitle => 'Unlock your cosmic side';

  @override
  String get cosmicNeedsBirthDateBody =>
      'Share your birthday when you like, and your daily sign guidance will appear here. Everything else in Mochi Moon works without it.';

  @override
  String get cosmicUnlockTitle => 'Unlock your cosmic side';

  @override
  String get cosmicUnlockButton => 'Unlock';

  @override
  String get cosmicUnlockFinish => 'Unlock Cosmic';

  @override
  String get cosmicUnlockPrivacy =>
      'Your birth details stay on your account and are never shared.';

  @override
  String get cosmicLockedArtLabel =>
      'Mochi the moon bunny waiting by the stars';

  @override
  String cosmicHeader(String sign, String date) {
    return '$sign · $date';
  }

  @override
  String cosmicMoonIn(String sign) {
    return 'Moon in $sign';
  }

  @override
  String get cosmicEnergyTitle => 'Today\'s energy';

  @override
  String get cosmicLoveTitle => 'Love';

  @override
  String get cosmicLuckyColorsTitle => 'Lucky colors';

  @override
  String get cosmicLuckyNumberTitle => 'Lucky number';

  @override
  String get cosmicAvoidTitle => 'Things to avoid';

  @override
  String get cosmicThaiColorsTitle => 'Thai colors';

  @override
  String get cosmicThaiBirthdayColor => 'Your birthday color';

  @override
  String get cosmicThaiTodayColor => 'Today\'s color';

  @override
  String get cosmicDisclaimer => 'For entertainment and self-reflection';

  @override
  String get moonTitle => 'Moon';

  @override
  String get moonPhaseNewMoon => 'New moon';

  @override
  String get moonPhaseWaxingCrescent => 'Waxing crescent';

  @override
  String get moonPhaseFirstQuarter => 'First quarter';

  @override
  String get moonPhaseWaxingGibbous => 'Waxing gibbous';

  @override
  String get moonPhaseFullMoon => 'Full moon';

  @override
  String get moonPhaseWaningGibbous => 'Waning gibbous';

  @override
  String get moonPhaseLastQuarter => 'Last quarter';

  @override
  String get moonPhaseWaningCrescent => 'Waning crescent';

  @override
  String moonIlluminated(int percent) {
    return '$percent% lit';
  }

  @override
  String moonNextNew(String date) {
    return 'Next new moon: $date';
  }

  @override
  String moonNextFull(String date) {
    return 'Next full moon: $date';
  }

  @override
  String get moonAffirmationNewMoon =>
      'I plant a gentle intention for myself, and I trust it to grow.';

  @override
  String get moonAffirmationWaxingCrescent =>
      'I take one small, kind step toward what I want.';

  @override
  String get moonAffirmationFirstQuarter =>
      'I can keep going at my own pace, and my effort matters.';

  @override
  String get moonAffirmationWaxingGibbous =>
      'I trust what I have started and I give it time to bloom.';

  @override
  String get moonAffirmationFullMoon =>
      'I am glowing, and I am grateful for how far I have come.';

  @override
  String get moonAffirmationWaningGibbous =>
      'I share what I have learned and I thank myself for it.';

  @override
  String get moonAffirmationLastQuarter =>
      'I let go of what feels heavy, and I forgive myself with ease.';

  @override
  String get moonAffirmationWaningCrescent =>
      'I rest, I soften, and I make room for a fresh start.';

  @override
  String get reduceMotionTitle => 'Reduce motion';

  @override
  String get reduceMotionSubtitle =>
      'Calmer cards: no tilting or sparkles. Already on if your phone removes animations';

  @override
  String get thaiColorsSettingTitle => 'Thai day colors';

  @override
  String get thaiColorsSettingSubtitle =>
      'Show your birthday color and today\'s color on Cosmic you';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'Same as my phone';

  @override
  String get languageFirstTitle => 'Choose your language';

  @override
  String get languageFirstBody =>
      'Pick the one that feels like home. You can change it any time in Me.';

  @override
  String get languageFirstContinue => 'Continue';

  @override
  String get signAries => 'Aries';

  @override
  String get signTaurus => 'Taurus';

  @override
  String get signGemini => 'Gemini';

  @override
  String get signCancer => 'Cancer';

  @override
  String get signLeo => 'Leo';

  @override
  String get signVirgo => 'Virgo';

  @override
  String get signLibra => 'Libra';

  @override
  String get signScorpio => 'Scorpio';

  @override
  String get signSagittarius => 'Sagittarius';

  @override
  String get signCapricorn => 'Capricorn';

  @override
  String get signAquarius => 'Aquarius';

  @override
  String get signPisces => 'Pisces';

  @override
  String get retroTitle => 'Retrogrades';

  @override
  String get retroMercury => 'Mercury';

  @override
  String get retroVenus => 'Venus';

  @override
  String get retroMars => 'Mars';

  @override
  String get retroJupiter => 'Jupiter';

  @override
  String get retroSaturn => 'Saturn';

  @override
  String retroStatusRetrograde(String planet, String date) {
    return '$planet is retrograde until $date';
  }

  @override
  String retroStatusNext(String planet, String date) {
    return 'Next $planet retrograde: $date';
  }

  @override
  String get retroStartsToday => 'Starts today';

  @override
  String get retroStartsTomorrow => 'Starts tomorrow';

  @override
  String retroStartsInDays(int days) {
    return 'Starts in $days days';
  }

  @override
  String get retroCardHint => 'See all retrogrades';

  @override
  String get retroTipsTitle => 'Gentle tips';

  @override
  String get retroTipMercury =>
      'A lovely time to revisit, rest and re-read. Double-check your plans, save your photos, and give messages a little extra time.';

  @override
  String get retroTipVenus =>
      'A tender season to reflect on what you value in love and friendship. Notice what feels true before starting something new.';

  @override
  String get retroTipMars =>
      'Your energy may feel slower. Choose rest over rushing, and let small, steady steps count.';

  @override
  String get retroTipJupiter =>
      'A slower season for growth. Savor what you have learned and let your dreams take shape at their own pace.';

  @override
  String get retroTipSaturn =>
      'A quiet time to review your routines and boundaries, with kindness toward yourself.';

  @override
  String get retroNowTitle => 'Right now';

  @override
  String get retroCalmTitle => 'All planets are moving forward';

  @override
  String get retroCalmBody =>
      'Nothing is retrograde at the moment, so enjoy the smooth flow.';

  @override
  String get retroTipMercury1 =>
      'Back up your photos and re-read messages before you send them.';

  @override
  String get retroTipMercury2 =>
      'Leave a little extra time for plans and trips.';

  @override
  String get retroTipMercury3 =>
      'Reconnect softly with someone or something you have missed.';

  @override
  String get retroTipVenus1 =>
      'Take your time before big choices about love or style.';

  @override
  String get retroTipVenus2 =>
      'Do something that makes you feel lovely, just because.';

  @override
  String get retroTipVenus3 => 'Notice who feels easy and warm to be around.';

  @override
  String get retroTipMars1 => 'Choose gentle movement over pushing hard.';

  @override
  String get retroTipMars2 =>
      'Pick one small task and let that be enough today.';

  @override
  String get retroTipMars3 =>
      'Pause and breathe before reacting when you feel frustrated.';

  @override
  String get retroTipJupiter1 => 'Celebrate how far you have already come.';

  @override
  String get retroTipJupiter2 => 'Return to a dream and let it grow slowly.';

  @override
  String get retroTipJupiter3 =>
      'Stay curious about what you have been learning.';

  @override
  String get retroTipSaturn1 => 'Tidy one routine that no longer fits you.';

  @override
  String get retroTipSaturn2 =>
      'Notice a boundary you would like to honor, and honor it kindly.';

  @override
  String get retroTipSaturn3 => 'Thank yourself for your steady effort.';

  @override
  String get retroCalendarTitle => 'Retrograde calendar';

  @override
  String get retroCalendarSubtitle =>
      'Colored days show when a planet is retrograde.';

  @override
  String get retroCalendarPrevious => 'Previous month';

  @override
  String get retroCalendarNext => 'Next month';

  @override
  String retroCalendarDay(String date, String planets) {
    return '$date: $planets retrograde';
  }

  @override
  String get retroAlertsTitle => 'Retrograde heads-ups';

  @override
  String get retroAlertsSubtitle =>
      'A gentle note the day before and the day a planet turns';

  @override
  String get retroAlertsPrePromptTitle => 'A soft cosmic heads-up?';

  @override
  String get retroAlertsPrePromptBody =>
      'Mochi Moon can send a gentle note the day before and the day a planet turns retrograde or direct. To do that, your phone will ask to allow notifications.';

  @override
  String get retroAlertNotificationTitle => 'Cosmic heads-up 🌙';

  @override
  String get retroAlertChannelName => 'Retrograde heads-ups';

  @override
  String get retroAlertChannelDescription =>
      'A gentle note around the days a planet turns retrograde or direct.';

  @override
  String retroAlertStartsTomorrow(String planet) {
    return '$planet turns retrograde tomorrow. A lovely moment to slow down and be kind to yourself.';
  }

  @override
  String retroAlertStartsToday(String planet) {
    return '$planet turns retrograde today. Take it softly and trust your own pace.';
  }

  @override
  String retroAlertEndsTomorrow(String planet) {
    return '$planet turns direct tomorrow. Things start to flow forward again.';
  }

  @override
  String retroAlertEndsToday(String planet) {
    return '$planet turns direct today. Welcome the fresh, steady momentum.';
  }

  @override
  String get accountDeleteTitle => 'Delete my account';

  @override
  String get accountDeleteSubtitle =>
      'Erase your profile, saved cards and progress, and start over';

  @override
  String get accountDeleteConfirmTitle => 'Delete your account?';

  @override
  String get accountDeleteConfirmBody =>
      'This permanently erases your profile, saved cards, progress and sign-in, both on this phone and from Mochi Moon. It cannot be undone.';

  @override
  String get accountDeleteConfirmAction => 'Delete';

  @override
  String get accountDeleteKeep => 'Keep my account';

  @override
  String get accountDeleteDeleting => 'Deleting your account...';

  @override
  String get accountDeleteOffline =>
      'You seem to be offline. Please connect and try again.';

  @override
  String get accountDeleteFinalTitle => 'Are you completely sure?';

  @override
  String get accountDeleteFinalBody =>
      'This is your last chance. Everything will be erased for good and Mochi Moon will start over as if you had just installed it.';

  @override
  String get accountDeleteFinalAction => 'Yes, erase everything';

  @override
  String get cosmicSignPickerLabel => 'Choose a sign to read';

  @override
  String get cosmicSignPickerLockedLabel => 'Read other signs, part of Premium';

  @override
  String cosmicSignPickerYou(String sign) {
    return '$sign (you)';
  }

  @override
  String get accountDeleteCancelled =>
      'Nothing was deleted. You are still signed in.';

  @override
  String get accountDeleteFailed =>
      'Something went wrong and nothing was deleted. Please try again.';

  @override
  String get chartTitle => 'Birth chart';

  @override
  String get chartButtonHint => 'See your Sun, Moon and Rising';

  @override
  String get chartReportCardTitle => 'Your full reading';

  @override
  String get chartReportCardBody =>
      'A longer, gentler read about your personality, feelings, love life, work and everyday habits.';

  @override
  String get reportTitle => 'Your full reading';

  @override
  String get reportPreparingTitle => 'Writing your reading';

  @override
  String get reportPreparingBody =>
      'The first parts take a minute or two. You can leave and come back; it keeps going.';

  @override
  String reportProgress(int ready, int total, int minutes) {
    return '$ready of $total parts ready · about $minutes min read';
  }

  @override
  String get reportWriting => 'Writing the next part…';

  @override
  String get reportFailedTitle => 'Some parts did not finish';

  @override
  String get reportFailedBody =>
      'Nothing is lost. Try again to write the missing parts.';

  @override
  String get reportBusyBody =>
      'You asked for a lot of readings in a short time. Please try again in a while.';

  @override
  String get reportOfflineTitle => 'You\'re offline';

  @override
  String get reportOfflineBody =>
      'Your full reading needs a connection the first time. Once it is written, it is saved on your phone.';

  @override
  String get reportPremiumTitle => 'Your full reading is part of Premium';

  @override
  String get reportPremiumBody =>
      'Premium opens the long, gentle reading of your chart. Your free chart stays just as it is.';

  @override
  String get premiumPreviewChip => 'Premium';

  @override
  String premiumPreviewSemantics(String what) {
    return '$what. Part of Premium. Opens the Premium page.';
  }

  @override
  String get reportPremiumAction => 'See Premium';

  @override
  String get reportUnavailableBody =>
      'The full reading is not available in this version yet.';

  @override
  String get chartBigThreeTitle => 'Your Big 3';

  @override
  String get chartPlacementsTitle => 'Placements';

  @override
  String get chartWheelLabel =>
      'Birth chart wheel. The placements are listed below.';

  @override
  String get chartBodySun => 'Sun';

  @override
  String get chartBodyMoon => 'Moon';

  @override
  String get chartBodyMercury => 'Mercury';

  @override
  String get chartBodyVenus => 'Venus';

  @override
  String get chartBodyMars => 'Mars';

  @override
  String get chartBodyJupiter => 'Jupiter';

  @override
  String get chartBodySaturn => 'Saturn';

  @override
  String get chartBodyUranus => 'Uranus';

  @override
  String get chartBodyNeptune => 'Neptune';

  @override
  String get chartBodyPluto => 'Pluto';

  @override
  String get chartBodyRising => 'Rising';

  @override
  String get chartBodyAscendant => 'Ascendant';

  @override
  String get chartBodyMidheaven => 'Midheaven';

  @override
  String chartRoleIn(String role, String sign) {
    return '$role in $sign';
  }

  @override
  String chartHouse(int number) {
    return 'House $number';
  }

  @override
  String get chartRetrograde => 'retrograde';

  @override
  String get chartApproximate => 'approximate';

  @override
  String chartRowLabel(String body, String sign, String degrees) {
    return '$body in $sign, $degrees';
  }

  @override
  String get chartNoTimeTitle => 'Add your birth time';

  @override
  String get chartNoTimeBody =>
      'Without it we can\'t find your Rising sign or your houses, and your Moon sign is only approximate.';

  @override
  String get chartNeedsBirthDateTitle => 'Your chart needs a birth date';

  @override
  String get chartNeedsBirthDateBody =>
      'Add your birth date to see your Sun, Moon and Rising.';

  @override
  String get chartHighLatitudeNote =>
      'Near the poles the Rising sign can be less reliable.';

  @override
  String get chartSunAries =>
      'You have a brave, bright spark. You shine when you start something new, and your courage can be gentle too.';

  @override
  String get chartSunTaurus =>
      'You are steady, warm and loyal. You glow when life feels cozy, and slow, patient steps are a strength.';

  @override
  String get chartSunGemini =>
      'You are curious, playful and quick with words. Your many sides are not a flaw, they are your charm.';

  @override
  String get chartSunCancer =>
      'You feel deeply and care for others with a soft heart. Your sensitivity is a gift, and you deserve the same tenderness.';

  @override
  String get chartSunLeo =>
      'You carry a warm, sunny presence. You love to shine and to cheer others on, and you are enough even on quiet days.';

  @override
  String get chartSunVirgo =>
      'You are thoughtful, caring and good with details. You are allowed to be kind to yourself, even when things are not perfect.';

  @override
  String get chartSunLibra =>
      'You bring balance, beauty and gentle harmony wherever you go. Your own needs matter as much as everyone else\'s.';

  @override
  String get chartSunScorpio =>
      'You feel things with depth and you are loyal to the core. Your intensity is a strength, and you can soften when you are ready.';

  @override
  String get chartSunSagittarius =>
      'You are adventurous, honest and full of hope. You grow whenever you follow your curiosity.';

  @override
  String get chartSunCapricorn =>
      'You are patient, determined and dependable. You can rest and still be proud of how far you have come.';

  @override
  String get chartSunAquarius =>
      'You are original, kind and a little bit dreamy. Your different way of seeing things is what makes you special.';

  @override
  String get chartSunPisces =>
      'You are gentle, imaginative and full of compassion. Your dreams are worth protecting, and so is your peace.';

  @override
  String get chartMoonAries =>
      'Your feelings arrive fast and bright. Give yourself a moment to breathe, and let your heart move at its own pace.';

  @override
  String get chartMoonTaurus =>
      'You feel safest with comfort and calm. Cozy routines, good food and soft things help your heart settle.';

  @override
  String get chartMoonGemini =>
      'Talking, writing or sharing helps you understand how you feel. It is okay if your moods change like the sky.';

  @override
  String get chartMoonCancer =>
      'You feel everything deeply, and home is where your heart rests. Be as gentle with yourself as you are with others.';

  @override
  String get chartMoonLeo =>
      'Your heart loves to be seen and appreciated. Kind words, from others and from you, help you glow.';

  @override
  String get chartMoonVirgo =>
      'You feel calm when things are tidy and useful. You can let small worries go, because you are doing well.';

  @override
  String get chartMoonLibra =>
      'You feel best when things are peaceful and fair. It is okay to say what you need, even when it feels hard.';

  @override
  String get chartMoonScorpio =>
      'Your feelings run deep and private. You can take your time before opening up, and trust those who have earned it.';

  @override
  String get chartMoonSagittarius =>
      'You feel free when you have space and hope. A walk, a laugh or a little adventure lifts your mood.';

  @override
  String get chartMoonCapricorn =>
      'You may keep your feelings close and tend to them quietly. Soft rest is just as important as hard work.';

  @override
  String get chartMoonAquarius =>
      'You make sense of feelings by stepping back and thinking them through. Your heart is warm even when it is quiet.';

  @override
  String get chartMoonPisces =>
      'Your heart is soft and picks up on every mood around you. Quiet time, music and dreaming help you recharge.';

  @override
  String get chartRisingAries =>
      'People may see you as bold, energetic and ready to go. Your confidence invites others to be brave too.';

  @override
  String get chartRisingTaurus =>
      'People may see you as calm, grounded and warm. Your steady presence makes others feel at ease.';

  @override
  String get chartRisingGemini =>
      'People may see you as bright, curious and easy to talk to. Your lively energy is a joy to be around.';

  @override
  String get chartRisingCancer =>
      'People may see you as gentle and caring. Your kindness makes others feel at home.';

  @override
  String get chartRisingLeo =>
      'People may see you as warm, confident and a little bit sparkly. Your presence lights up a room.';

  @override
  String get chartRisingVirgo =>
      'People may see you as thoughtful, neat and kind. Your quiet care shows in the little things.';

  @override
  String get chartRisingLibra =>
      'People may see you as graceful, friendly and easygoing. Your charm helps others feel welcome.';

  @override
  String get chartRisingScorpio =>
      'People may see you as calm, magnetic and a little mysterious. Your depth makes others curious.';

  @override
  String get chartRisingSagittarius =>
      'People may see you as cheerful, open and adventurous. Your optimism is contagious.';

  @override
  String get chartRisingCapricorn =>
      'People may see you as composed, capable and wise. Your calm focus earns trust.';

  @override
  String get chartRisingAquarius =>
      'People may see you as unique, friendly and a bit unexpected. Your originality stands out in a lovely way.';

  @override
  String get chartRisingPisces =>
      'People may see you as soft, dreamy and kind. Your gentle aura makes others feel understood.';

  @override
  String get analyticsConsentTitle => 'Help Mochi Moon grow?';

  @override
  String get analyticsConsentBody =>
      'We would love to count simple taps, like how many cards get finished, so we can make the app kinder and better. We never share your birthday, your partners\' names, your journal or the words on your cards. You can change this any time in Me.';

  @override
  String get analyticsConsentAllow => 'Yes, count my taps';

  @override
  String get analyticsConsentDecline => 'No thanks';

  @override
  String get analyticsSettingTitle => 'Share anonymous usage';

  @override
  String get analyticsSettingSubtitle =>
      'Simple counts like cards completed. Never birthdays, names, journal or card text';

  @override
  String get announcementsTitle => 'App news';

  @override
  String get announcementsSubtitle =>
      'A rare note when something new comes to Mochi Moon';

  @override
  String get meAboutSubtitle => 'How readings work, and open-source licenses';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutReadingsTitle => 'About readings';

  @override
  String get aboutReadingsBody =>
      'Everything you read here is for entertainment and self-reflection. It is a gentle prompt to notice how you feel, never a rule for how your day or your life must go.';

  @override
  String get aboutZodiacTitle => 'Which zodiac we use';

  @override
  String get aboutZodiacBody =>
      'Mochi Moon uses the Western tropical zodiac. Your Sun, Moon and Rising signs are worked out from your birthday, and the Moon phase and retrograde dates follow the real sky.';

  @override
  String get aboutWritingTitle => 'How readings are written';

  @override
  String get aboutWritingBody =>
      'Daily readings are written ahead of time with the help of AI, in a soft and encouraging tone. There is no chat: nobody types questions to an AI here.';

  @override
  String get aboutCareTitle => 'What we leave out';

  @override
  String get aboutCareBody =>
      'Readings never predict health, death, pregnancy, money or legal outcomes, and they never say a relationship will fail or succeed. For anything like that, please talk to someone you trust or a qualified professional.';

  @override
  String get aboutLicenses => 'Open-source licenses';

  @override
  String get mePartnersSubtitle => 'People you compare your chart with';

  @override
  String get partnersTitle => 'Partners';

  @override
  String get partnersEmptyTitle => 'No partners yet';

  @override
  String get partnersEmptyBody =>
      'Add someone\'s birthday to see how your charts get along. It\'s just for fun and self-reflection.';

  @override
  String get partnersAdd => 'Add a partner';

  @override
  String partnersLimitFree(int free, int premium) {
    return 'Free includes $free partner. Premium keeps up to $premium.';
  }

  @override
  String partnersLimitPremium(int count) {
    return 'You\'ve saved the most partners you can ($count). Delete one to add someone new.';
  }

  @override
  String partnersTileSubtitle(String sign, String date) {
    return '$sign · Born $date';
  }

  @override
  String partnersDeleteTooltip(String name) {
    return 'Delete $name';
  }

  @override
  String partnersDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get partnersDeleteBody =>
      'Their birth details will be removed from this phone and from your account. You can add them again anytime.';

  @override
  String get partnersDeleteConfirm => 'Delete';

  @override
  String get partnersAddTitle => 'Add a partner';

  @override
  String get partnersEditTitle => 'Edit partner';

  @override
  String get partnersNicknameLabel => 'Nickname';

  @override
  String get partnersNicknameHelper =>
      'A nickname is perfect. Only you can see it.';

  @override
  String get partnersBirthDateLabel => 'Birthday';

  @override
  String get partnersBirthDateChoose => 'Choose a date';

  @override
  String get partnersBirthTimeLabel => 'Birth time (optional)';

  @override
  String get partnersBirthPlaceLabel => 'Birthplace (optional)';

  @override
  String get partnersBirthPlaceNeeded =>
      'Add a birthplace so we can read the birth time in the right time zone.';

  @override
  String get partnersLightHint =>
      'Without a birth time you\'ll get a light reading, which is still lovely.';

  @override
  String get partnersPrivacy =>
      'Only you can see this, and you can delete it anytime.';

  @override
  String get partnersSave => 'Save';

  @override
  String get partnersSaveFailed => 'We couldn\'t save this. Please try again.';

  @override
  String get partnersLimitReached => 'You\'ve reached the partner limit.';

  @override
  String get partnersNotFound => 'We couldn\'t find this partner.';

  @override
  String partnersEditTooltip(String name) {
    return 'Edit $name';
  }

  @override
  String get compatTitle => 'Compatibility';

  @override
  String get compatNeedsBirthDateTitle => 'Add your birthday to compare';

  @override
  String get compatNeedsBirthDateBody =>
      'Your own birth date is needed to read how your chart and theirs meet.';

  @override
  String compatHeader(String yourSign, String name, String theirSign) {
    return 'You ($yourSign) + $name ($theirSign)';
  }

  @override
  String compatMeterLabel(int score) {
    return 'Compatibility $score percent';
  }

  @override
  String get compatSummaryLow =>
      'A gentle pairing with plenty of room to grow together.';

  @override
  String get compatSummaryMid => 'A warm pairing with lovely moments of ease.';

  @override
  String get compatSummaryHigh =>
      'A bright pairing where your charts really sing together.';

  @override
  String get compatLightLabel => 'Light reading';

  @override
  String get compatLightBody =>
      'Without both birth times this is a lighter reading. Adding a birth time and place makes it richer.';

  @override
  String get compatThemeRomance => 'Romance';

  @override
  String get compatThemeEmotional => 'Emotional';

  @override
  String get compatThemeCommunication => 'Communication';

  @override
  String compatThemeScore(String theme, int score) {
    return '$theme $score percent';
  }

  @override
  String get compatFlowTitle => 'What flows';

  @override
  String get compatGrowTitle => 'Where you grow';

  @override
  String get compatQuiet =>
      'Your charts are quiet together, and that\'s okay. Every connection finds its own rhythm.';

  @override
  String compatAspectPair(String yours, String name, String theirs) {
    return 'Your $yours + $name\'s $theirs';
  }

  @override
  String get compatAspectConjunction =>
      'These two blend together, so this part of you feels naturally close.';

  @override
  String get compatAspectSextile =>
      'These two cooperate easily, with a friendly give and take.';

  @override
  String get compatAspectTrine =>
      'These two flow together with an effortless, easy warmth.';

  @override
  String get compatAspectSquare =>
      'These two have a spark that asks for patience and understanding.';

  @override
  String get compatAspectOpposition =>
      'These two pull in different directions, so balance and listening help here.';

  @override
  String get meProfileTitle => 'Edit profile';

  @override
  String get meProfileSubtitle => 'Your name, birthday and focus areas';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditBirthDateLabel => 'Birthday';

  @override
  String get profileEditBirthDateChoose => 'Choose a date';

  @override
  String get profileEditBirthTimeLabel => 'Birth time (optional)';

  @override
  String get profileEditBirthPlaceLabel => 'Birthplace';

  @override
  String get profileEditBirthPlaceNeeded =>
      'Add a birthplace so we can read the birth time in the right time zone.';

  @override
  String get profileEditFocusLabel => 'What you\'d like more of';

  @override
  String get profileEditNote =>
      'Changing your birth details updates your birth chart, your readings and your compatibility results.';

  @override
  String get profileEditSave => 'Save';

  @override
  String get profileEditSaved => 'Profile updated.';

  @override
  String get ritualIntroBody =>
      'Two soft minutes, just for you: how you feel, three kind cards and one thing you\'re grateful for.';

  @override
  String get ritualStart => 'Begin my ritual';

  @override
  String get ritualBrowseDeck => 'Browse the deck';

  @override
  String ritualStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get ritualNext => 'Next';

  @override
  String get ritualSkip => 'Skip';

  @override
  String ritualCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards left in your ritual',
      one: '1 card left in your ritual',
    );
    return '$_temp0';
  }

  @override
  String get ritualGratitudeTitle => 'One thing you\'re grateful for';

  @override
  String get ritualGratitudeBody =>
      'Take a slow breath and think of one small thing that felt good today.';

  @override
  String get ritualFinish => 'Finish my ritual';

  @override
  String get ritualDoneTitle => 'Your ritual is done';

  @override
  String get ritualDoneBody =>
      'You showed up for yourself today. That always counts.';

  @override
  String get ritualDoneSemantics => 'Ritual complete';

  @override
  String get gratitudeTitle => 'Gratitude jar';

  @override
  String get gratitudeMeSubtitle => 'Little thanks and small wins, kept safe';

  @override
  String get gratitudeHint => 'Something good, big or small';

  @override
  String get gratitudeAdd => 'Drop a star in the jar';

  @override
  String get gratitudeDayFull =>
      'That\'s three for today. Your jar will be happy to see you tomorrow.';

  @override
  String gratitudeJarCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars in your jar',
      one: '1 star in your jar',
      zero: 'Your jar is waiting for its first star',
    );
    return '$_temp0';
  }

  @override
  String gratitudeJarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A jar with $count paper stars',
      one: 'A jar with 1 paper star',
      zero: 'An empty jar',
    );
    return '$_temp0';
  }

  @override
  String get gratitudeOpenJar => 'Open the jar';

  @override
  String get gratitudeAnother => 'Another one';

  @override
  String get gratitudeCloseJar => 'Close the jar';

  @override
  String get gratitudeNothingYet =>
      'Nothing from earlier days yet. Come back tomorrow and your jar will have something for you.';

  @override
  String get gratitudeEmptyTitle => 'Your jar is empty';

  @override
  String get gratitudeEmptyBody =>
      'Write one thing you\'re thankful for, or a small win, and it becomes a paper star.';

  @override
  String get gratitudeTodayHeader => 'Today';

  @override
  String get gratitudeEarlierHeader => 'Earlier';

  @override
  String get gratitudeDelete => 'Delete this star';

  @override
  String get gratitudeDeleteTitle => 'Delete this star?';

  @override
  String get gratitudeDeleteBody =>
      'It will be removed from your jar for good.';

  @override
  String get gratitudeDeleteConfirm => 'Delete';

  @override
  String get gratitudeCancel => 'Keep it';

  @override
  String get gratitudePrivacyNote => 'Only you can read what you write here.';

  @override
  String get ownCardsTitle => 'My own cards';

  @override
  String get ownCardsMeSubtitle => 'Affirmations in your own words';

  @override
  String get ownCardsEmptyTitle => 'No cards of your own yet';

  @override
  String get ownCardsEmptyBody =>
      'Write something kind you want to hear. It joins your deck.';

  @override
  String get ownCardsWrite => 'Write a card';

  @override
  String ownCardsSlotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count free cards left',
      one: '1 free card left',
      zero: 'No free cards left',
    );
    return '$_temp0';
  }

  @override
  String get ownCardsNewTitle => 'A card in your words';

  @override
  String get ownCardsEditTitle => 'Edit your card';

  @override
  String get ownCardsHint => 'I am allowed to take my time';

  @override
  String get ownCardsPickArt => 'Pick a picture';

  @override
  String get ownCardsSave => 'Save my card';

  @override
  String get ownCardsShare => 'Share as an image';

  @override
  String get ownCardsDelete => 'Delete this card';

  @override
  String get ownCardsDeleteTitle => 'Delete this card?';

  @override
  String get ownCardsDeleteBody =>
      'It will be removed from your deck for good, and it frees a spot.';

  @override
  String get ownCardsDeleteConfirm => 'Delete';

  @override
  String get ownCardsKeep => 'Keep it';

  @override
  String get ownCardsCouldNotSave =>
      'That card could not be saved. Please try again.';

  @override
  String get ownCardsLimitTitle => 'Your free card is in use';

  @override
  String get ownCardsLimitBody =>
      'Free accounts keep one card of their own. Premium lets you write as many as you like. You can also delete your card to make room.';

  @override
  String get ownCardsLimitOk => 'OK';

  @override
  String get ownCardsPrivacyNote => 'Only you can read what you write here.';

  @override
  String get breatheTitle => 'Breathe with Mochi';

  @override
  String get breatheMeSubtitle => 'One calm minute';

  @override
  String get breatheIntro =>
      'One minute, just you and Mochi. Breathe in for 4, hold for 4, breathe out for 4, hold for 4. You can stop any time.';

  @override
  String get breatheStart => 'Begin';

  @override
  String get breatheIn => 'Breathe in';

  @override
  String get breatheHold => 'Hold';

  @override
  String get breatheOut => 'Breathe out';

  @override
  String breatheRound(int round, int total) {
    return 'Round $round of $total';
  }

  @override
  String get breatheStop => 'Stop for now';

  @override
  String get breatheFinishTitle => 'Well done, lovely';

  @override
  String get breatheFinishBody =>
      'You gave yourself one calm minute. That counts.';

  @override
  String get breatheAgain => 'Breathe again';

  @override
  String get breatheDone => 'Done';

  @override
  String get breatheHapticOn => 'Soft vibration is on';

  @override
  String get breatheHapticOff => 'Soft vibration is off';

  @override
  String get hardDayButton => 'Hard day?';

  @override
  String get journeyHardDayLink => 'Having a hard day? Open the hard-day kit';

  @override
  String get hardDayTitle => 'A hard day';

  @override
  String get hardDayIntro =>
      'It is okay to have a hard day. You do not have to fix anything right now. Here are a few gentle things you can try, one at a time.';

  @override
  String get hardDayBreatheSub => 'One slow minute, just breathing';

  @override
  String get hardDayCardsTitle => 'Three kind words for you';

  @override
  String get hardDayJarSub => 'Read the good things you saved';

  @override
  String get hardDayHelpTitle => 'Help';

  @override
  String get hardDayHelpNote =>
      'Mochi Moon is not a substitute for professional help. If you are in danger, please contact your local emergency services or someone you trust right now.';

  @override
  String get hardDayHelpFind =>
      'To find a helpline in your country, search for your national crisis or mental health line, or ask someone you trust to help you look.';

  @override
  String get questCardTitle => 'Today\'s tiny kindness';

  @override
  String get questMarkDone => 'I did it';

  @override
  String get questSwap => 'Try another';

  @override
  String get questDoneNote => 'Done for today. Well done, you.';

  @override
  String get journeysTitle => 'Journeys';

  @override
  String get journeysMeSubtitle => 'Gentle programs, one small day at a time';

  @override
  String get journeysIntro =>
      'Pick one journey. Each day has three cards, a tiny kindness and a moment to reflect. Missed a day? It simply waits for you.';

  @override
  String journeyDaysCount(int count) {
    return '$count days';
  }

  @override
  String get journeyFreeTag => 'Free';

  @override
  String get journeyPremiumTag => 'Premium';

  @override
  String get journeyLockedNote => 'This journey is part of Premium.';

  @override
  String get journeyInProgressTag => 'In progress';

  @override
  String get journeyFinishedTag => 'Finished';

  @override
  String get journeyStart => 'Start this journey';

  @override
  String journeyContinue(int day) {
    return 'Continue with day $day';
  }

  @override
  String journeyProgressLabel(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String get journeyOtherRunning =>
      'You\'re on another journey. Finish it first, then pick a new one.';

  @override
  String get journeyDoneToday =>
      'Today\'s day is done. Come back tomorrow for the next one.';

  @override
  String get journeyWaitsNote =>
      'No rush. Your journey waits for you right where you stopped.';

  @override
  String journeyCardsCaption(int day) {
    return 'Read each card aloud. Day $day.';
  }

  @override
  String get journeyQuestHeader => 'Today\'s tiny kindness';

  @override
  String get journeyReflectionHeader => 'A moment to reflect';

  @override
  String get journeyReflectionHint =>
      'Write whatever comes, just for you (optional)';

  @override
  String journeyFinishDay(int day) {
    return 'Finish day $day';
  }

  @override
  String journeyCompleteTitle(String title) {
    return 'You finished $title';
  }

  @override
  String get journeyCompleteBody =>
      'Be proud of every small day you showed up for yourself.';

  @override
  String get journeyShare => 'Share my journey';

  @override
  String journeyShareText(String title) {
    return 'I finished the $title journey';
  }

  @override
  String get journeyNotFound => 'We couldn\'t find that journey.';

  @override
  String get lettersTitle => 'Letters to future me';

  @override
  String get lettersMeSubtitle =>
      'Write to the you of 30, 90 or 365 days from now';

  @override
  String get lettersIntro =>
      'Write a kind note to your future self. It stays sealed until the day you choose, and only you can read it.';

  @override
  String get lettersEmptyTitle => 'No letters yet';

  @override
  String get lettersEmptyBody =>
      'Your first letter to future you is waiting to be written.';

  @override
  String get lettersWrite => 'Write a letter';

  @override
  String get lettersLimitTitle => 'Your free letter is still sealed';

  @override
  String get lettersLimitBody =>
      'Free accounts can keep one letter sealed at a time. Once it opens, you can write another. Premium lets you seal as many as you like.';

  @override
  String get lettersLimitOk => 'OK';

  @override
  String letterSealedUntil(String date) {
    return 'Sealed until $date';
  }

  @override
  String get letterReady => 'Ready to open';

  @override
  String letterWrittenOn(String date) {
    return 'Written on $date';
  }

  @override
  String get letterWriteTitle => 'A letter to future me';

  @override
  String get letterHint => 'Dear future me...';

  @override
  String get letterDelayLabel => 'Open it in';

  @override
  String letterDelayDays(int count) {
    return '$count days';
  }

  @override
  String get letterPrivacyNote =>
      'Private: only you can read this. It is never used by the app or shared.';

  @override
  String get letterSeal => 'Seal the letter';

  @override
  String get letterSealConfirmTitle => 'Seal this letter?';

  @override
  String letterSealConfirmBody(String date) {
    return 'You will not be able to read or change it until $date.';
  }

  @override
  String get letterSealConfirmYes => 'Seal it';

  @override
  String get letterSealConfirmNo => 'Keep writing';

  @override
  String letterSealedNote(String date) {
    return 'This letter is sealed. It will open on $date.';
  }

  @override
  String letterNoReminder(String date) {
    return 'Notifications are off, so open Letters on $date to read it.';
  }

  @override
  String get letterDelete => 'Delete this letter';

  @override
  String get letterDeleteTitle => 'Delete this letter?';

  @override
  String get letterDeleteBody =>
      'It will be removed for good, and you will not be able to read it.';

  @override
  String get letterDeleteConfirm => 'Delete';

  @override
  String get letterDeleteKeep => 'Keep it';

  @override
  String get letterNotificationTitle => 'A letter from you';

  @override
  String get letterNotificationBody => 'A letter you wrote is ready to open.';

  @override
  String get letterChannelName => 'Letters to future me';

  @override
  String get letterChannelDescription =>
      'Tells you when a letter you sealed is ready to open.';

  @override
  String get letterNotFound => 'We could not find that letter.';

  @override
  String get weeklyLetterTitle => 'Your week, from Mochi';

  @override
  String get weeklyLetterOpen => 'Read your letter';

  @override
  String get weeklyLetterLoading => 'Mochi is writing your letter...';

  @override
  String get weeklyLetterTeaser => 'Mochi wrote you a letter about your week.';

  @override
  String get weeklyLetterPremiumTitle => 'A weekly letter from Mochi';

  @override
  String get weeklyLetterPremiumBody =>
      'Every Sunday Mochi writes you a short, warm letter about your week. Premium keeps it coming.';

  @override
  String get weeklyLetterOfflineNote =>
      'Mochi could not reach her desk this time, so here is a little note until she can write yours.';

  @override
  String get weeklyLetterRetry => 'Try again';

  @override
  String get weeklyLetterClose => 'Close';

  @override
  String get weeklyLetterFallbackTitle => 'A fresh start with Mochi';

  @override
  String get weeklyLetterFallbackBody =>
      'Hello you. Every week is a new page, and this one is yours to fill in softly. You do not need to do everything to be doing enough. A deep breath, a kind word to yourself, or one small thing you enjoy already counts. Mochi is proud of you for being here. When you are ready, your next card is waiting, and so is a little quest that takes only a minute. Be gentle with yourself this week, the way you would be with a friend you love.';

  @override
  String get weeklyLetterNotificationTitle => 'A letter from Mochi';

  @override
  String get weeklyLetterNotificationBody =>
      'Mochi wrote you a little letter about your week.';

  @override
  String get weeklyLetterChannelName => 'Weekly letter';

  @override
  String get weeklyLetterChannelDescription =>
      'Tells you on Sunday that your weekly letter from Mochi is ready.';

  @override
  String get mascotRoomTitle => 'Mochi\'s room';

  @override
  String get mascotRoomMeSubtitle =>
      'Outfits and little things Mochi has earned';

  @override
  String get mascotRoomIntro =>
      'Mochi collects gifts as you show up for yourself. Nothing is ever taken away, so come back whenever you like.';

  @override
  String get mascotRoomEmptyTitle => 'Mochi\'s room is waiting';

  @override
  String get mascotRoomEmptyBody =>
      'Your first gift arrives with a 3-day streak. There is no rush.';

  @override
  String get mascotSlotOutfit => 'Outfit';

  @override
  String get mascotSlotFloor => 'Floor';

  @override
  String get mascotSlotShelf => 'Shelf';

  @override
  String get mascotSlotWindow => 'Window';

  @override
  String get mascotSlotWall => 'Wall';

  @override
  String get mascotSlotOther => 'Room';

  @override
  String get mascotItemOn => 'In use. Tap to take off.';

  @override
  String get mascotItemTapToUse => 'Tap to use';

  @override
  String mascotItemLockedStreak(int days) {
    return 'Reach a $days-day streak';
  }

  @override
  String mascotItemLockedJourney(String journey) {
    return 'Finish the $journey journey';
  }

  @override
  String get mascotItemLockedOther => 'Keep showing up to earn this';

  @override
  String get mascotPremiumTag => 'Premium';

  @override
  String get mascotPremiumNote =>
      'Mochi keeps this gift. Using it is part of Premium.';

  @override
  String get moodInsightsTitle => 'Your patterns';

  @override
  String moodInsightsNotEnough(int days) {
    return 'Log your mood on $days more days and Mochi will share a few gentle patterns.';
  }

  @override
  String get moodInsightsNone =>
      'Nothing stands out yet, and that is perfectly fine. Keep checking in when you feel like it.';

  @override
  String moodInsightMostOften(String mood, int count, int total) {
    return '$mood showed up on $count of your $total logged days.';
  }

  @override
  String get moodInsightMostOftenStep =>
      'Whatever it was, you noticed and checked in. That is a kind thing to do for yourself.';

  @override
  String get moodInsightRitualLift =>
      'You logged a good mood more often on days you finished your ritual.';

  @override
  String get moodInsightRitualLiftStep =>
      'Your two minutes seem to matter. Come back tomorrow if you would like to.';

  @override
  String get moodInsightsPremiumTitle => 'Mood insights are part of Premium';

  @override
  String get moodInsightsPremiumBody =>
      'Premium shares a few gentle patterns from your own check-ins, kept on your phone.';

  @override
  String mascotItemSemantics(String name, String status) {
    return '$name, $status';
  }

  @override
  String get recapTitle => 'Monthly glow';

  @override
  String get recapMeSubtitle => 'Look back at last month';

  @override
  String recapHeadline(String month) {
    return 'Your $month glow';
  }

  @override
  String recapDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days you showed up',
      one: 'day you showed up',
    );
    return '$_temp0';
  }

  @override
  String recapTopMood(String mood) {
    return 'Most often you felt $mood';
  }

  @override
  String get recapFavouriteLabel => 'A card you loved';

  @override
  String get recapShare => 'Share your glow';

  @override
  String get recapWelcomeBackTitle => 'Welcome back';

  @override
  String get recapWelcomeBackBody =>
      'A new month is a soft place to start. Mochi kept your spot warm.';

  @override
  String recapTodayTitle(String month) {
    return 'Your $month glow is ready';
  }

  @override
  String get recapTodayOpen => 'See it';

  @override
  String get paywallClose => 'Close';

  @override
  String get paywallTitle => 'Mochi Premium';

  @override
  String get paywallBenefitJourneys =>
      'Every self-love journey, at your own pace';

  @override
  String get paywallBenefitLetter => 'A warm weekly letter from Mochi';

  @override
  String get paywallBenefitCards =>
      'Write as many cards of your own as you like';

  @override
  String get paywallYearly => 'Yearly';

  @override
  String get paywallMonthly => 'Monthly';

  @override
  String get paywallTrial => '7 days free';

  @override
  String get paywallStartTrial => 'Start free trial';

  @override
  String get paywallSubscribe => 'Subscribe';

  @override
  String get paywallUnavailable =>
      'Premium is not available to buy just yet. Everything free stays free.';

  @override
  String get paywallRestore => 'Restore purchases';

  @override
  String get aboutPrivacy => 'Privacy policy';

  @override
  String get aboutTerms => 'Terms of use';

  @override
  String get aboutLinkFailed =>
      'We could not open that page. Please try again later.';

  @override
  String get paywallManage => 'Manage subscription in Google Play';

  @override
  String get paywallManageFailed =>
      'We could not open Google Play. You can manage subscriptions there under Payments and subscriptions.';

  @override
  String get mePremiumTitle => 'Mochi Moon Premium';

  @override
  String get mePremiumSubtitleFree => 'Journeys, weekly letter and more';

  @override
  String get mePremiumSubtitleActive =>
      'You have Premium. Manage it in Google Play.';

  @override
  String get paywallRestoreFound => 'Welcome back, your Premium is restored.';

  @override
  String get paywallRestoreNone => 'We could not find an earlier purchase.';

  @override
  String get paywallFinePrint =>
      'Subscriptions renew until you cancel them in Google Play. Prices are set by the store.';

  @override
  String get paywallSeePremium => 'See Premium';

  @override
  String get paywallBuyFailed =>
      'We could not start the purchase. Please try again in a moment.';

  @override
  String get paywallWelcome =>
      'Welcome to Mochi Premium. Thank you for being kind to yourself.';
}
