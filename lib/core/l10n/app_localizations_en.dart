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
  String get cosmicTitle => 'Cosmic you';

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
  String get cosmicNeedsBirthDateTitle => 'Your stars need a date';

  @override
  String get cosmicNeedsBirthDateBody =>
      'Share your birth date and your daily guidance will appear here.';

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
  String get thaiColorsSettingTitle => 'Thai day colors';

  @override
  String get thaiColorsSettingSubtitle =>
      'Show your birthday color and today\'s color on Cosmic you';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'Same as my phone';

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
}
