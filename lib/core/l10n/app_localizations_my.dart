// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appName => 'Mochi Moon';

  @override
  String get tabToday => 'ဒီနေ့';

  @override
  String get tabDeck => 'ကတ်များ';

  @override
  String get tabCosmic => 'စကြဝဠာ';

  @override
  String get tabMe => 'ကိုယ်တိုင်';

  @override
  String get todayTitle => 'ဒီနေ့';

  @override
  String todayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Self Love လုပ်တာ $count ရက် ဆက်တိုက်',
    );
    return '$_temp0';
  }

  @override
  String get todayNoStreak => 'ဒီနေ့ကစပြီး Self Love ကို နေ့တိုင်းလုပ်ကြည့်ပါ';

  @override
  String get todayBody =>
      'Mochi နဲ့အတူ ကိုယ့်အတွက် နူးညံ့တဲ့ 2 မိနစ်လောက် အချိန်ပေးပါ။ ကြင်နာတဲ့ ကတ်လေးတချို့ကို ဖတ်ပြီး စိတ်ထဲ စိမ့်ဝင်လာပါစေ။';

  @override
  String get todayStart => 'ဒီနေ့အတွက် ကတ်တွေ ဖတ်မယ်';

  @override
  String get deckTitle => 'သင့် Self Love ကတ်များ';

  @override
  String get deckEmptyBody =>
      'နူးညံ့တဲ့ သတိပေးစကားလေးတွေ မကြာခင် ရောက်လာတော့မယ်။';

  @override
  String deckStreakSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ရက်ဆက်တိုက်',
    );
    return '$_temp0';
  }

  @override
  String deckCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ဒီနေ့အတွက် ကတ် $count ကတ် ကျန်ပါသေးတယ်',
    );
    return '$_temp0';
  }

  @override
  String get deckLimitTitle => 'တောက်ပနေပြီ ✨';

  @override
  String get deckLimitBody =>
      'ဒီနေ့အတွက် ကတ်တွေ ဖတ်ပြီးပါပြီ။ နောက်ထပ်ကတ်တွေအတွက် မနက်ဖြန် ပြန်လာခဲ့နော်။';

  @override
  String get deckActionSkip => 'နောက်ကတ်';

  @override
  String get deckActionSave => 'ဒါက ငါပဲ';

  @override
  String get deckActionShare => 'မျှဝေမယ်';

  @override
  String get deckActionUndo => 'ပြန်လုပ်မယ်';

  @override
  String get deckTimerSemantics => 'အသံထွက်ဖတ်ချိန်တိုင်းကိရိယာ';

  @override
  String get deckTimerReady => 'ပွတ်ဆွဲဖို့ အသင့်ဖြစ်ပြီ';

  @override
  String get shareFailed =>
      'မျှဝေမှုစာမျက်နှာကို ဖွင့်လို့မရပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get categorySelfLove => 'Self Love';

  @override
  String get categoryConfidence => 'ကိုယ့်ကိုယ်ကို ယုံကြည်မှု';

  @override
  String get categoryHealing => 'စိတ်သက်သာရာရခြင်း';

  @override
  String get categoryStudyWork => 'စာသင်ခြင်းနဲ့ အလုပ်';

  @override
  String get categoryBodyKindness => 'ကိုယ့်ခန္ဓာကိုယ်အပေါ် ကြင်နာမှု';

  @override
  String get categoryCalm => 'စိတ်အေးချမ်းမှု';

  @override
  String get cosmicTitle => 'ကိုယ့်ရဲ့ စကြဝဠာ';

  @override
  String get mePlaceholderTitle => 'ကိုယ်တိုင်အတွက်';

  @override
  String get moodHappy => 'ပျော်တယ်';

  @override
  String get moodCalm => 'စိတ်အေးတယ်';

  @override
  String get moodTired => 'ပင်ပန်းတယ်';

  @override
  String get moodSad => 'ဝမ်းနည်းတယ်';

  @override
  String get moodAnxious => 'စိုးရိမ်ပူပန်တယ်';

  @override
  String get moodInLove => 'အချစ်စိတ်ဝင်နေတယ်';

  @override
  String get moodCheckInTitle => 'ဒီနေ့ ဘယ်လိုခံစားနေရလဲ။';

  @override
  String get moodScreenTitle => 'ကိုယ့်စိတ်ခံစားချက်တွေ';

  @override
  String get moodMeSubtitle => 'စိတ်အခြေအနေကို မှတ်သားပြီး တစ်လတာကို ကြည့်မယ်';

  @override
  String get moodPreviousMonth => 'ပြီးခဲ့တဲ့လ';

  @override
  String get moodNextMonth => 'နောက်လ';

  @override
  String get moodDayNone => 'ဒီနေ့အတွက် စိတ်အခြေအနေ မသိမ်းထားရသေးပါဘူး။';

  @override
  String moodDayValue(String date, String mood) {
    return '$date: $mood';
  }

  @override
  String moodDaySemanticsNone(String date) {
    return '$date၊ စိတ်အခြေအနေ မရှိပါ';
  }

  @override
  String moodDaySemantics(String date, String mood) {
    return '$date၊ $mood';
  }

  @override
  String get journalTitle => 'ကိုယ့်မှတ်တမ်း';

  @override
  String get meJournalSubtitle => 'ကိုယ့်စိတ်နဲ့ ကိုက်ညီတဲ့ ကတ်လေးတွေ';

  @override
  String get journalEmptyTitle => 'ဘာမှ မသိမ်းထားရသေးပါဘူး';

  @override
  String get journalEmptyBody =>
      'ကြိုက်တဲ့ကတ်လေးတွေကို ညာဘက်ပွတ်ဆွဲလိုက်ပါ၊ ဒီမှာ သိမ်းထားပေးမယ်နော်။';

  @override
  String get journalFilterAll => 'အားလုံး';

  @override
  String get journalRemoveTitle => 'မှတ်တမ်းထဲကနေ ဖယ်မလား။';

  @override
  String get journalRemoveBody =>
      'ဒီကတ်ကို မှတ်တမ်းထဲကနေ ဖယ်လိုက်ပါမယ်။ နောက်မှလည်း ပြန်သိမ်းနိုင်ပါတယ်။';

  @override
  String get journalRemoveConfirm => 'ဖယ်မယ်';

  @override
  String get journalKeep => 'သိမ်းထားမယ်';

  @override
  String get journalClose => 'ပိတ်မယ်';

  @override
  String get reminderTitle => 'နေ့စဉ် သတိပေးချက်';

  @override
  String get reminderSubtitle => 'notifications ထဲမှာ နူးညံ့တဲ့ကတ်လေးတစ်ကတ်';

  @override
  String get reminderTimeLabel => 'သတိပေးမယ့်အချိန်';

  @override
  String get reminderPrePromptTitle => 'နေ့တိုင်း သတိပေးချက်လေး လိုချင်လား။';

  @override
  String get reminderPrePromptBody =>
      'Mochi Moon က ကိုယ်ရွေးထားတဲ့အချိန်မှာ နူးညံ့တဲ့ကတ်လေးတစ်ကတ်ကို တစ်နေ့တစ်ခါ ပို့ပေးနိုင်ပါတယ်။ ဒီလိုလုပ်ဖို့ ဖုန်းက notifications ခွင့်ပြုမလားလို့ မေးပါလိမ့်မယ်။';

  @override
  String get reminderPrePromptAllow => 'အဆင်ပြေတယ်';

  @override
  String get reminderPrePromptLater => 'အခုတော့ မဟုတ်သေးဘူး';

  @override
  String get reminderPermissionDenied =>
      'Mochi Moon အတွက် notifications ပိတ်ထားပါတယ်။ ဖုန်းရဲ့ settings ထဲမှာ ပြန်ဖွင့်နိုင်ပါတယ်။';

  @override
  String get reminderNotificationTitle => 'Mochi Moon ကတ်လေး ✨';

  @override
  String get reminderChannelName => 'နေ့စဉ် သတိပေးချက်';

  @override
  String get reminderChannelDescription =>
      'ကိုယ်ရွေးထားတဲ့အချိန်မှာ နေ့တိုင်း နူးညံ့တဲ့ကတ်လေးတစ်ကတ်။';

  @override
  String get onboardingWelcomeTitle => 'Mochi Moon မှ ကြိုဆိုပါတယ်';

  @override
  String get onboardingWelcomeBody =>
      'ကိုယ်က ဘယ်လောက် အံ့ဩစရာကောင်းလဲဆိုတာ သတိရစေမယ့် နူးညံ့တဲ့ကတ်လေးတွေပါ။ တစ်ခုချင်းစီကို အသံထွက်ဖတ်ပြီး စိတ်ထဲ စိမ့်ဝင်လာပါစေ။';

  @override
  String onboardingTryCards(int count) {
    return 'ကတ် $count ကတ် စမ်းကြည့်မယ်';
  }

  @override
  String onboardingCardProgress(int current, int total) {
    return 'ကတ် $current / $total';
  }

  @override
  String get onboardingSaveTitle =>
      'ကတ်တွေကို သိမ်းထားပြီး စကြဝဠာဖတ်ရှုချက်လေး ရယူလိုက်ပါ';

  @override
  String get onboardingSaveBody =>
      'ကြိုက်ခဲ့တဲ့ကတ်တွေက မှတ်တမ်းထဲမှာ စောင့်နေပါတယ်။ စကြဝဠာဖတ်ရှုချက်လေးလည်း မကြာခင် ရောက်လာတော့မယ်။';

  @override
  String get onboardingContinue => 'ဆက်လုပ်မယ်';

  @override
  String get readAloudHint => 'အသံထွက်ဖတ်ကြည့်ပါ ✨';

  @override
  String get entertainmentNote =>
      'ဖျော်ဖြေရေးနဲ့ ကိုယ့်ကိုယ်ကို ပြန်လည်ဆင်ခြင်ဖို့အတွက်';

  @override
  String get stateLoading => 'မှော်ဆန်တဲ့အရာလေးတွေ စုဆောင်းနေပါတယ်…';

  @override
  String get stateErrorTitle => 'တစ်ခုခု လွဲချော်သွားတယ်';

  @override
  String get stateErrorBody => 'ပြန်စမ်းကြည့်ရအောင်နော်။';

  @override
  String get stateRetry => 'ထပ်စမ်းကြည့်မယ်';

  @override
  String get stateOffline =>
      'အင်တာနက်မရှိပါဘူး။ သိမ်းထားပေးထားတာတွေကို ပြနေပါတယ်။';

  @override
  String get stateEmptyTitle => 'ဒီမှာ ဘာမှ မရှိသေးဘူး';

  @override
  String get illustrationOnboardingWelcome =>
      'လာဗင်ဒါရောင်ညကောင်းကင်အောက်က တောက်ပနေတဲ့ လခြမ်းပေါ်မှာ လက်ပြနေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationOnboardingSave =>
      'တောက်ပနေတဲ့ ကတ်လေးတွေကို ပွေ့ဖက်ထားတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationEmptyDeck =>
      'တောက်ပနေတဲ့ နှလုံးပုံလေးကို ကြည့်နေတဲ့ လယုန်လေး Mochi၊ အိပ်ချင်စရာ လခြမ်းပေါ်မှာ ထိုင်နေတယ်';

  @override
  String get illustrationCalm =>
      'လွင့်မျောနေတဲ့ ပန်းပွင့်ချပ်လေးတွေနဲ့ ကြယ်တွေကြားမှာ မျက်လုံးမှိတ်ပြီး ငြိမ်းချမ်းစွာ ထိုင်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationConfidence =>
      'တောက်ပနေတဲ့ လခြမ်းပေါ်မှာ လက်ကို တင်ပါးပေါ်တင်ပြီး ဂုဏ်ယူစွာ ရပ်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationHealing =>
      'ကြယ်လေးတွေပါတဲ့ စောင်ကို ခြုံထားပြီး လက်ဖက်ရည်ပူပူလေးတစ်ခွက်ကို ပြုံးကြည့်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationSelfWorth =>
      'တောက်ပနေတဲ့ နှလုံးပုံကို ပြနေတဲ့ လက်ကိုင်မှန်လေးကို ကိုင်ထားတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationRest =>
      'လခြမ်းအောက်က တိမ်ပျော့ပျော့လေးပေါ်မှာ အိပ်နေတဲ့ လယုန်လေး Mochi';

  @override
  String illustrationZodiac(String sign) {
    return 'တောက်ပနေတဲ့ $sign ကြယ်စုအောက်မှာ $sign ဝတ်စုံဝတ်ထားတဲ့ လယုန်လေး Mochi';
  }

  @override
  String get signInGoogle => 'Google နဲ့ ဆက်လုပ်မယ်';

  @override
  String get signInFailed => 'အကောင့်ဝင်လို့ မရပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get signInOffline =>
      'အင်တာနက်မရှိသလိုပါပဲ။ ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String profileStepProgress(int current, int total) {
    return 'အဆင့် $current / $total';
  }

  @override
  String get profileBack => 'နောက်သို့';

  @override
  String get profileNameTitle => 'ဘယ်လိုခေါ်ရမလဲ။';

  @override
  String get profileNameBody =>
      'နာမည် ဒါမှမဟုတ် ချစ်စနိုးခေါ်တဲ့နာမည်လေးဆို အဆင်ပြေပါတယ်။';

  @override
  String get profileNameLabel => 'နာမည်';

  @override
  String get profileBirthDateTitle => 'မွေးနေ့က ဘယ်ရက်လဲ။';

  @override
  String get profileBirthDateBody =>
      'သင့် Sun sign နဲ့ စကြဝဠာဖတ်ရှုချက်လေးက ဒီကနေ စပါတယ်။';

  @override
  String profileBirthDateChosen(String date) {
    return '$date မှာ မွေးဖွားခဲ့ပါတယ်';
  }

  @override
  String get profileBirthTimeTitle => 'ဘယ်အချိန်မှာ မွေးဖွားခဲ့လဲ။';

  @override
  String get profileBirthTimeBody =>
      'မဖြည့်လည်းရပါတယ်။ Moon sign နဲ့ rising sign ကို ပိုတိကျစေပါတယ်။';

  @override
  String get profileBirthTimeChoose => 'အချိန်ရွေးပါ';

  @override
  String get profileBirthTimeChange => 'အချိန်ပြောင်းမယ်';

  @override
  String get profileBirthTimeUnknown => 'မသိဘူး';

  @override
  String profileBirthTimeChosen(String time) {
    return 'မွေးချိန် $time';
  }

  @override
  String get profileBirthTimeNone => 'မွေးချိန်မသိလည်း အဆင်ပြေပါတယ်။';

  @override
  String get profileBirthPlaceTitle => 'ဘယ်နေရာမှာ မွေးဖွားခဲ့လဲ။';

  @override
  String get profileBirthPlaceBodyRequired =>
      'ဒီနေရာရဲ့ time zone နဲ့ ကိုက်ညီအောင် မွေးချိန်ကို ဖတ်ရှုပေးပါတယ်။';

  @override
  String get profileBirthPlaceBodyOptional =>
      'မဖြည့်လည်းရပါတယ်။ အနီးဆုံးမြို့ကို ရှာပါ၊ ဒါမှမဟုတ် ကျော်လိုက်လို့ရပါတယ်။';

  @override
  String get profileBirthPlaceLabel => 'မြို့ကို ရှာပါ';

  @override
  String get profileBirthPlaceNoMatches =>
      'နေရာမတွေ့ပါဘူး။ အနီးအနားက မြို့ကြီးတစ်မြို့ကို ရှာကြည့်ပါ။';

  @override
  String get profileBirthPlaceLoadFailed => 'နေရာစာရင်းကို ဖွင့်လို့မရပါဘူး။';

  @override
  String profileBirthPlaceChosen(String place) {
    return '$place မှာ မွေးဖွားခဲ့ပါတယ်';
  }

  @override
  String get profileBirthPlaceChange => 'တခြားနေရာတစ်ခု ရွေးပါ';

  @override
  String get profileReminderTitle => 'နေ့တိုင်း သတိပေးချက်လေး လိုချင်လား။';

  @override
  String get profileReminderBody =>
      'တစ်နေ့တစ်ခါ နူးညံ့တဲ့ကတ်လေးတစ်ကတ် ပို့ပေးမယ်။ အချိန်မရွေး ပြောင်းနိုင်ပါတယ်။';

  @override
  String profileReminderAt(String time) {
    return '$time မှာ သတိပေးပါ';
  }

  @override
  String get profileReminderChange => 'အချိန်ပြောင်းမယ်';

  @override
  String get profileReminderOn => 'သတိပေးပါ';

  @override
  String get profileReminderSkip => 'အခုတော့ ကျော်မယ်';

  @override
  String get profileFocusTitle => 'ဘယ်အရာတွေ ပိုလိုချင်လဲ။';

  @override
  String profileFocusBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'အများဆုံး $count ခု ရွေးပါ။',
    );
    return '$_temp0';
  }

  @override
  String get profileFinish => 'စကြမယ်';

  @override
  String get profileSaveFailed => 'သိမ်းလို့မရပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get cosmicNeedsBirthDateTitle =>
      'ကိုယ့်ရဲ့ စကြဝဠာဆန်တဲ့ဘက်လေးကို ဖော်ထုတ်ကြည့်ပါ';

  @override
  String get cosmicNeedsBirthDateBody =>
      'ကိုယ်အဆင်သင့်ဖြစ်တဲ့အခါ မွေးနေ့ကို မျှဝေပေးပါ၊ နေ့စဉ် ရာသီခွင်အလိုက် လမ်းညွှန်ချက်လေးကို ဒီမှာ ပြပေးမယ်နော်။ ဒါပေမဲ့ Mochi Moon ရဲ့ တခြားအရာအားလုံးကိုတော့ မွေးနေ့မထည့်ဘဲ သုံးလို့ရပါတယ်။';

  @override
  String get cosmicUnlockTitle =>
      'ကိုယ့်ရဲ့ စကြဝဠာဆန်တဲ့ဘက်လေးကို ဖော်ထုတ်ကြည့်ပါ';

  @override
  String get cosmicUnlockButton => 'ဖွင့်မယ်';

  @override
  String get cosmicUnlockFinish => 'စကြဝဠာကို ဖွင့်မယ်';

  @override
  String get cosmicUnlockPrivacy =>
      'မွေးဖွားမှုအချက်အလက်တွေက ကိုယ့်အကောင့်ထဲမှာပဲ ရှိနေပြီး ဘယ်သူ့ကိုမှ မမျှဝေပါဘူး။';

  @override
  String get cosmicLockedArtLabel =>
      'ကြယ်တွေအနားမှာ စောင့်နေတဲ့ လယုန်လေး Mochi';

  @override
  String cosmicHeader(String sign, String date) {
    return '$sign · $date ရက်နေ့';
  }

  @override
  String cosmicMoonIn(String sign) {
    return 'Moon က $sign မှာ';
  }

  @override
  String get cosmicEnergyTitle => 'ဒီနေ့ရဲ့ စွမ်းအင်';

  @override
  String get cosmicLoveTitle => 'အချစ်';

  @override
  String get cosmicLuckyColorsTitle => 'ကံကောင်းစေတဲ့အရောင်များ';

  @override
  String get cosmicLuckyNumberTitle => 'ကံကောင်းစေတဲ့နံပါတ်';

  @override
  String get cosmicAvoidTitle => 'ရှောင်သင့်တဲ့အရာများ';

  @override
  String get cosmicThaiColorsTitle => 'ထိုင်းရိုးရာအရောင်များ';

  @override
  String get cosmicThaiBirthdayColor => 'ကိုယ့်မွေးနေ့အရောင်';

  @override
  String get cosmicThaiTodayColor => 'ဒီနေ့အရောင်';

  @override
  String get cosmicDisclaimer =>
      'ဖျော်ဖြေရေးနဲ့ ကိုယ့်ကိုယ်ကို ပြန်လည်ဆင်ခြင်ဖို့အတွက်';

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
    return '$percent% လင်းနေတယ်';
  }

  @override
  String moonNextNew(String date) {
    return 'နောက်လာမယ့် new moon: $date';
  }

  @override
  String moonNextFull(String date) {
    return 'နောက်လာမယ့် full moon: $date';
  }

  @override
  String get moonAffirmationNewMoon =>
      'ငါ့အတွက် နူးညံ့တဲ့ ရည်ရွယ်ချက်လေးတစ်ခု ချမှတ်ပြီး အဲဒါ တဖြည်းဖြည်း ကြီးထွားလာမယ်လို့ ယုံကြည်တယ်။';

  @override
  String get moonAffirmationWaxingCrescent =>
      'ငါလိုချင်တဲ့အရာဆီကို ကြင်နာတဲ့ ခြေလှမ်းသေးသေးလေးတစ်လှမ်း လှမ်းတယ်။';

  @override
  String get moonAffirmationFirstQuarter =>
      'ငါ ကိုယ့်အရှိန်နဲ့ကိုယ် ဆက်လျှောက်နိုင်တယ်၊ ငါ့ရဲ့ ကြိုးစားမှုကလည်း တန်ဖိုးရှိတယ်။';

  @override
  String get moonAffirmationWaxingGibbous =>
      'ငါ စတင်ထားတာကို ယုံကြည်ပြီး ပွင့်လန်းလာဖို့ အချိန်ပေးတယ်။';

  @override
  String get moonAffirmationFullMoon =>
      'ငါ တောက်ပနေတယ်၊ ဒီအထိ ရောက်လာနိုင်ခဲ့တာအတွက် ကျေးဇူးတင်တယ်။';

  @override
  String get moonAffirmationWaningGibbous =>
      'ငါ သင်ယူခဲ့တာတွေကို မျှဝေပြီး အဲဒီအတွက် ကိုယ့်ကိုယ်ကို ကျေးဇူးတင်တယ်။';

  @override
  String get moonAffirmationLastQuarter =>
      'လေးလံတယ်လို့ ခံစားရတာတွေကို လွှတ်ချပြီး ကိုယ့်ကိုယ်ကို အေးအေးဆေးဆေး ခွင့်လွှတ်တယ်။';

  @override
  String get moonAffirmationWaningCrescent =>
      'ငါ အနားယူတယ်၊ စိတ်ကို ပျော့ပျောင်းစေတယ်၊ အသစ်စဖို့ နေရာလေး ဖန်တီးတယ်။';

  @override
  String get reduceMotionTitle => 'လှုပ်ရှားမှု လျှော့မယ်';

  @override
  String get reduceMotionSubtitle =>
      'ပိုငြိမ်သက်တဲ့ ကတ်တွေ: စောင်းတာနဲ့ တလက်လက်တောက်တာတွေ မရှိတော့ပါဘူး။ ဖုန်းမှာ animation တွေကို ဖယ်ထားပြီးသားဆိုရင် ဒီ setting က ဖွင့်ထားပြီးသားပါ။';

  @override
  String get thaiColorsSettingTitle => 'ထိုင်းရိုးရာ နေ့အလိုက်အရောင်များ';

  @override
  String get thaiColorsSettingSubtitle =>
      'ကိုယ့်ရဲ့ စကြဝဠာမှာ မွေးနေ့အရောင်နဲ့ ဒီနေ့အရောင်ကို ပြမယ်';

  @override
  String get languageTitle => 'ဘာသာစကား';

  @override
  String get languageSystem => 'ဖုန်းမှာ သတ်မှတ်ထားတဲ့ ဘာသာစကားအတိုင်း';

  @override
  String get languageFirstTitle => 'ဘာသာစကားကို ရွေးပါ';

  @override
  String get languageFirstBody =>
      'အိမ်လို နွေးထွေးတယ်လို့ ခံစားရတဲ့ ဘာသာစကားကို ရွေးပါ။ ကိုယ်တိုင်ထဲမှာ အချိန်မရွေး ပြောင်းလို့ရပါတယ်။';

  @override
  String get languageFirstContinue => 'ဆက်လုပ်မယ်';

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
  String get retroTitle => 'retrograde ကာလများ';

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
    return '$planet က $date အထိ retrograde ဖြစ်နေပါတယ်';
  }

  @override
  String retroStatusNext(String planet, String date) {
    return 'နောက်လာမယ့် $planet retrograde: $date';
  }

  @override
  String get retroStartsToday => 'ဒီနေ့ စတင်ပါတယ်';

  @override
  String get retroStartsTomorrow => 'မနက်ဖြန် စတင်ပါတယ်';

  @override
  String retroStartsInDays(int days) {
    return 'စတင်ဖို့ $days ရက်လိုပါသေးတယ်';
  }

  @override
  String get retroCardHint => 'retrograde အားလုံးကို ကြည့်မယ်';

  @override
  String get retroTipsTitle => 'နူးညံ့တဲ့ အကြံပြုချက်လေးများ';

  @override
  String get retroTipMercury =>
      'ပြန်လည်ကြည့်ရှု၊ အနားယူပြီး ထပ်ဖတ်ဖို့ လှပတဲ့အချိန်လေးပါ။ အစီအစဉ်တွေကို သေချာပြန်စစ်၊ ဓာတ်ပုံတွေကို သိမ်းထားပြီး စာတွေကိုလည်း ပို့ဖို့ အချိန်နည်းနည်းပိုပေးပါ။';

  @override
  String get retroTipVenus =>
      'အချစ်နဲ့ မိတ်ဆွေမှုမှာ ကိုယ်တန်ဖိုးထားတာတွေကို ပြန်စဉ်းစားဖို့ နူးညံ့တဲ့ကာလလေးပါ။ အသစ်တစ်ခု မစခင် ကိုယ့်အတွက် တကယ်မှန်ကန်တယ်လို့ ခံစားရတာကို သတိထားကြည့်ပါ။';

  @override
  String get retroTipMars =>
      'ကိုယ့်စွမ်းအင်က ပိုနှေးနေသလို ခံစားရနိုင်တယ်။ အလောတကြီးလုပ်တာထက် အနားယူဖို့ ရွေးပြီး ဖြည်းဖြည်းမှန်မှန် လှမ်းတဲ့ ခြေလှမ်းလေးတွေကိုလည်း တန်ဖိုးထားပါ။';

  @override
  String get retroTipJupiter =>
      'တိုးတက်ဖို့ အရှိန်နှေးတဲ့ကာလလေးပါ။ သင်ယူခဲ့တာတွေကို အရသာခံပြီး ကိုယ့်အိပ်မက်တွေကိုလည်း ကိုယ့်အရှိန်နဲ့ကိုယ် ပုံဖော်ခွင့်ပေးပါ။';

  @override
  String get retroTipSaturn =>
      'ကိုယ့်ရဲ့ နေ့စဉ်လုပ်ရိုးလုပ်စဉ်တွေနဲ့ သတ်မှတ်ထားတဲ့ စည်းမျဉ်းတွေကို ကြင်ကြင်နာနာ ပြန်သုံးသပ်ဖို့ တိတ်ဆိတ်အေးချမ်းတဲ့အချိန်လေးပါ။';

  @override
  String get retroNowTitle => 'အခုလောလောဆယ်';

  @override
  String get retroCalmTitle => 'ဂြိုဟ်အားလုံး ရှေ့ကို ရွေ့လျားနေပါတယ်';

  @override
  String get retroCalmBody =>
      'လောလောဆယ် ဘယ်ဂြိုဟ်မှ retrograde မဖြစ်နေပါဘူး။ အရာရာ ချောချောမွေ့မွေ့ စီးဆင်းနေတာကို ခံစားလိုက်ပါ။';

  @override
  String get retroTipMercury1 =>
      'ဓာတ်ပုံတွေကို backup လုပ်ထားပြီး မပို့ခင် message တွေကို ပြန်ဖတ်ပါ။';

  @override
  String get retroTipMercury2 =>
      'အစီအစဉ်တွေနဲ့ ခရီးစဉ်တွေအတွက် အချိန်နည်းနည်းပိုချန်ထားပါ။';

  @override
  String get retroTipMercury3 =>
      'လွမ်းနေခဲ့တဲ့သူတစ်ယောက် ဒါမှမဟုတ် အရာတစ်ခုနဲ့ နူးနူးညံ့ညံ့ ပြန်ဆက်သွယ်ကြည့်ပါ။';

  @override
  String get retroTipVenus1 =>
      'အချစ်ရေး ဒါမှမဟုတ် style နဲ့ပတ်သက်တဲ့ အရေးကြီးဆုံးဖြတ်ချက်တွေ မချခင် အချိန်ယူပါ။';

  @override
  String get retroTipVenus2 =>
      'အကြောင်းပြချက်မလိုဘဲ ကိုယ့်ကိုယ်ကို လှပတယ်လို့ ခံစားရစေမယ့် အရာလေးတစ်ခု လုပ်ကြည့်ပါ။';

  @override
  String get retroTipVenus3 =>
      'ဘယ်သူနဲ့အတူရှိရတာ သက်တောင့်သက်သာနဲ့ နွေးထွေးသလဲ သတိထားကြည့်ပါ။';

  @override
  String get retroTipMars1 =>
      'ကိုယ့်ကိုယ်ကို အတင်းတွန်းအားပေးတာထက် ညင်ညင်သာသာ လှုပ်ရှားဖို့ ရွေးပါ။';

  @override
  String get retroTipMars2 =>
      'လုပ်စရာလေးတစ်ခုကိုပဲ ရွေးပြီး ဒီနေ့အတွက် အဲဒီလောက်နဲ့ လုံလောက်တယ်လို့ သဘောထားပါ။';

  @override
  String get retroTipMars3 =>
      'စိတ်တိုလာတဲ့အခါ ချက်ချင်းမတုံ့ပြန်ခင် ခဏရပ်ပြီး အသက်ရှူပါ။';

  @override
  String get retroTipJupiter1 => 'ဒီအထိ ရောက်လာနိုင်ခဲ့တာကို ဂုဏ်ပြုလိုက်ပါ။';

  @override
  String get retroTipJupiter2 =>
      'အိပ်မက်တစ်ခုဆီ ပြန်သွားပြီး ဖြည်းဖြည်းချင်း ကြီးထွားလာခွင့်ပေးပါ။';

  @override
  String get retroTipJupiter3 =>
      'ကိုယ်သင်ယူနေခဲ့တာတွေအပေါ် စူးစမ်းချင်စိတ်ကို ဆက်ထိန်းထားပါ။';

  @override
  String get retroTipSaturn1 =>
      'ကိုယ့်နဲ့ အဆင်မပြေတော့တဲ့ နေ့စဉ်လုပ်ရိုးလုပ်စဉ်တစ်ခုကို ပြင်ဆင်ကြည့်ပါ။';

  @override
  String get retroTipSaturn2 =>
      'လေးစားလိုက်နာချင်တဲ့ စည်းမျဉ်းတစ်ခုကို သတိထားမိအောင် ကြည့်ပြီး ကြင်ကြင်နာနာ လိုက်နာပါ။';

  @override
  String get retroTipSaturn3 =>
      'ဖြည်းဖြည်းမှန်မှန် ကြိုးစားခဲ့တဲ့ ကိုယ့်ကိုယ်ကို ကျေးဇူးတင်လိုက်ပါ။';

  @override
  String get retroCalendarTitle => 'Retrograde ပြက္ခဒိန်';

  @override
  String get retroCalendarSubtitle =>
      'အရောင်ခြယ်ထားတဲ့ရက်တွေက ဂြိုဟ်တစ်လုံး retrograde ဖြစ်နေတဲ့အချိန်ကို ပြပါတယ်။';

  @override
  String get retroCalendarPrevious => 'ပြီးခဲ့တဲ့လ';

  @override
  String get retroCalendarNext => 'နောက်လ';

  @override
  String retroCalendarDay(String date, String planets) {
    return '$date: $planets retrograde ဖြစ်နေပါတယ်';
  }

  @override
  String get retroAlertsTitle => 'Retrograde သတိပေးချက်လေးများ';

  @override
  String get retroAlertsSubtitle =>
      'ဂြိုဟ်တစ်လုံး retrograde/direct စဝင်မယ့်နေ့မတိုင်ခင်တစ်ရက်နဲ့ အဲဒီနေ့မှာ နူးညံ့တဲ့ သတိပေးချက်လေး ပို့ပေးမယ်';

  @override
  String get retroAlertsPrePromptTitle => 'စကြဝဠာဆီက သတိပေးချက်လေး လိုချင်လား။';

  @override
  String get retroAlertsPrePromptBody =>
      'Mochi Moon က ဂြိုဟ်တစ်လုံး retrograde ဒါမှမဟုတ် direct စဝင်မယ့်နေ့မတိုင်ခင်တစ်ရက်နဲ့ အဲဒီနေ့မှာ နူးညံ့တဲ့ သတိပေးချက်လေး ပို့ပေးနိုင်ပါတယ်။ ဒီလိုလုပ်ဖို့ ဖုန်းက notifications ခွင့်ပြုမလားလို့ မေးပါလိမ့်မယ်။';

  @override
  String get retroAlertNotificationTitle => 'စကြဝဠာဆီက သတိပေးချက်လေး 🌙';

  @override
  String get retroAlertChannelName => 'Retrograde သတိပေးချက်လေးများ';

  @override
  String get retroAlertChannelDescription =>
      'ဂြိုဟ်တစ်လုံး retrograde ဒါမှမဟုတ် direct စဝင်မယ့်နေ့ဝန်းကျင်မှာ နူးညံ့တဲ့ သတိပေးချက်လေး ပို့ပေးမယ်။';

  @override
  String retroAlertStartsTomorrow(String planet) {
    return '$planet က မနက်ဖြန် retrograde စဝင်တော့မယ်။ အရှိန်လျှော့ပြီး ကိုယ့်ကိုယ်ကို ကြင်ကြင်နာနာ ဆက်ဆံဖို့ လှပတဲ့အချိန်လေးပါ။';
  }

  @override
  String retroAlertStartsToday(String planet) {
    return '$planet က ဒီနေ့ retrograde စဝင်ပါတယ်။ ဖြည်းဖြည်းနဲ့ အေးအေးဆေးဆေးနေပြီး ကိုယ့်အရှိန်အတိုင်း သွားပါနော်။';
  }

  @override
  String retroAlertEndsTomorrow(String planet) {
    return '$planet က မနက်ဖြန် direct ပြန်ဖြစ်တော့မယ်။ အရာတွေက ရှေ့ကို ပြန်ပြီး စီးဆင်းလာတော့မယ်။';
  }

  @override
  String retroAlertEndsToday(String planet) {
    return '$planet က ဒီနေ့ direct ပြန်ဖြစ်ပါတယ်။ လန်းဆန်းပြီး တည်ငြိမ်တဲ့ အရှိန်အဟုန်အသစ်ကို ကြိုဆိုလိုက်ပါ။';
  }

  @override
  String get accountDeleteTitle => 'အကောင့်ကို ဖျက်မယ်';

  @override
  String get accountDeleteSubtitle =>
      'profile၊ သိမ်းထားတဲ့ကတ်တွေနဲ့ တိုးတက်မှုမှတ်တမ်းကို ဖျက်ပြီး အစကနေ ပြန်စမယ်';

  @override
  String get accountDeleteConfirmTitle => 'အကောင့်ကို ဖျက်မှာ သေချာပြီလား။';

  @override
  String get accountDeleteConfirmBody =>
      'ဒီလုပ်ဆောင်ချက်က profile၊ သိမ်းထားတဲ့ကတ်တွေ၊ တိုးတက်မှုမှတ်တမ်းနဲ့ sign-in အချက်အလက်တွေကို ဒီဖုန်းထဲကရော Mochi Moon ထဲကပါ အပြီးဖျက်ပစ်မှာပါ။ ပြန်ပြင်လို့မရပါဘူး။';

  @override
  String get accountDeleteConfirmAction => 'ဖျက်မယ်';

  @override
  String get accountDeleteKeep => 'အကောင့်ကို ဆက်ထားမယ်';

  @override
  String get accountDeleteDeleting => 'အကောင့်ကို ဖျက်နေပါတယ်...';

  @override
  String get accountDeleteOffline =>
      'အင်တာနက်မရှိသလိုပါပဲ။ ချိတ်ဆက်ပြီး ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get accountDeleteFinalTitle => 'တကယ်ပဲ သေချာပြီလား။';

  @override
  String get accountDeleteFinalBody =>
      'ဒါက နောက်ဆုံးအခွင့်အရေးပါ။ အရာအားလုံးကို အပြီးတိုင်ဖျက်ပြီး Mochi Moon ကို ခုမှ install လုပ်ထားသလို အစကနေ ပြန်စပါမယ်။';

  @override
  String get accountDeleteFinalAction => 'ဟုတ်ကဲ့၊ အားလုံးဖျက်မယ်';

  @override
  String get cosmicSignPickerLabel => 'ဖတ်ရှုဖို့ ရာသီခွင်တစ်ခု ရွေးပါ';

  @override
  String cosmicSignPickerYou(String sign) {
    return '$sign (ကိုယ်တိုင်)';
  }

  @override
  String get accountDeleteCancelled =>
      'ဘာမှ မဖျက်လိုက်ပါဘူး။ အကောင့်ထဲမှာ ဆက်ဝင်ထားဆဲပါ။';

  @override
  String get accountDeleteFailed =>
      'တစ်ခုခု အဆင်မပြေဖြစ်သွားပြီး ဘာမှ မဖျက်လိုက်ပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get chartTitle => 'Birth chart';

  @override
  String get chartButtonHint => 'Sun, Moon နဲ့ Rising ကို ကြည့်မယ်';

  @override
  String get chartReportCardTitle => 'အပြည့်အစုံဖတ်ရှုချက်';

  @override
  String get chartReportCardBody =>
      'ကိုယ့်ရဲ့ ပင်ကိုယ်စရိုက်၊ ခံစားချက်တွေ၊ အချစ်ရေး၊ အလုပ်နဲ့ နေ့စဉ်အလေ့အကျင့်လေးတွေအကြောင်း ပိုရှည်ပြီး နူးညံ့တဲ့ ဖတ်ရှုချက်လေးပါ။';

  @override
  String get reportTitle => 'အပြည့်အစုံဖတ်ရှုချက်';

  @override
  String get reportPreparingTitle => 'ဖတ်ရှုချက်ကို ရေးနေပါတယ်';

  @override
  String get reportPreparingBody =>
      'အစပိုင်းလေးတွေ ပြီးဖို့ 1 မိနစ်၊ 2 မိနစ်လောက် ကြာနိုင်ပါတယ်။ ထွက်သွားပြီး နောက်မှပြန်လာလည်း ရပါတယ်။ ဆက်ရေးနေမှာပါ။';

  @override
  String reportProgress(int ready, int total, int minutes) {
    return 'အပိုင်း $ready / $total ပြီးပါပြီ · ဖတ်ချိန် $minutes မိနစ်လောက်';
  }

  @override
  String get reportWriting => 'နောက်တစ်ပိုင်းကို ရေးနေပါတယ်…';

  @override
  String get reportFailedTitle => 'တချို့အပိုင်းတွေ မပြီးသေးပါဘူး';

  @override
  String get reportFailedBody =>
      'ဘာမှ ပျောက်မသွားပါဘူး။ မပြီးသေးတဲ့အပိုင်းတွေကို ရေးဖို့ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get reportBusyBody =>
      'အချိန်တိုအတွင်း ဖတ်ရှုချက်တွေ အများကြီး တောင်းထားပါတယ်။ ခဏနေမှ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get reportOfflineTitle => 'အင်တာနက်မရှိပါဘူး';

  @override
  String get reportOfflineBody =>
      'အပြည့်အစုံဖတ်ရှုချက်ကို ပထမဆုံးအကြိမ် ရယူဖို့ အင်တာနက်ချိတ်ဆက်မှု လိုပါတယ်။ ရေးပြီးသွားရင် ဖုန်းထဲမှာ သိမ်းထားပေးမှာပါ။';

  @override
  String get reportUnavailableBody =>
      'ဒီဗားရှင်းမှာ အပြည့်အစုံဖတ်ရှုချက်ကို မရနိုင်သေးပါဘူး။';

  @override
  String get chartBigThreeTitle => 'ကိုယ့် Big 3';

  @override
  String get chartPlacementsTitle => 'ဂြိုဟ်တည်နေရာများ';

  @override
  String get chartWheelLabel =>
      'Birth chart စက်ဝိုင်းပုံ။ ဂြိုဟ်တည်နေရာတွေကို အောက်မှာ ဖော်ပြထားပါတယ်။';

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
    return '$role က $sign မှာ';
  }

  @override
  String chartHouse(int number) {
    return 'House $number';
  }

  @override
  String get chartRetrograde => 'retrograde';

  @override
  String get chartApproximate => 'ခန့်မှန်းခြေ';

  @override
  String chartRowLabel(String body, String sign, String degrees) {
    return '$body က $sign မှာ၊ $degrees';
  }

  @override
  String get chartNoTimeTitle => 'မွေးချိန် ထည့်ပါ';

  @override
  String get chartNoTimeBody =>
      'မွေးချိန်မရှိရင် Rising sign နဲ့ house တွေကို ရှာမရသလို Moon sign ကိုလည်း ခန့်မှန်းခြေပဲ သိနိုင်ပါတယ်။';

  @override
  String get chartNeedsBirthDateTitle =>
      'Birth chart အတွက် မွေးနေ့ရက် လိုပါတယ်';

  @override
  String get chartNeedsBirthDateBody =>
      'မွေးနေ့ရက် ထည့်ပြီး ကိုယ့် Sun, Moon နဲ့ Rising ကို ကြည့်လိုက်ပါ။';

  @override
  String get chartHighLatitudeNote =>
      'ဝင်ရိုးစွန်းဒေသနားမှာ Rising sign က တိကျမှုနည်းနိုင်ပါတယ်။';

  @override
  String get chartSunAries =>
      'ရဲရင့်ပြီး တောက်ပတဲ့ မီးပွားလေးတစ်ခု ရှိတယ်။ အသစ်တစ်ခု စတင်တဲ့အခါ ပိုတောက်ပလာပြီး ရဲစွမ်းသတ္တိကလည်း နူးညံ့နိုင်ပါတယ်။';

  @override
  String get chartSunTaurus =>
      'တည်ငြိမ်၊ နွေးထွေးပြီး သစ္စာရှိတယ်။ ဘဝက သက်တောင့်သက်သာရှိတဲ့အခါ ပိုတောက်ပလာတယ်။ ဖြည်းဖြည်းနဲ့ စိတ်ရှည်လက်ရှည် လှမ်းတဲ့ခြေလှမ်းတွေက အားသာချက်ပါ။';

  @override
  String get chartSunGemini =>
      'စူးစမ်းချင်စိတ်ရှိပြီး ပျော်ပျော်နေတတ်ကာ စကားပြောလည်း သွက်တယ်။ ဘက်စုံရှိတာက အားနည်းချက်မဟုတ်ဘူး၊ ကိုယ့်ရဲ့ ဆွဲဆောင်မှုပါ။';

  @override
  String get chartSunCancer =>
      'နက်နက်ရှိုင်းရှိုင်း ခံစားတတ်ပြီး နူးညံ့တဲ့စိတ်နဲ့ တခြားသူတွေကို ဂရုစိုက်တတ်တယ်။ အာရုံခံစားလွယ်တာက လက်ဆောင်တစ်ခုလိုပါပဲ၊ ကိုယ်လည်း အဲဒီလို နူးညံ့ကြင်နာမှုကို ခံစားထိုက်တယ်။';

  @override
  String get chartSunLeo =>
      'နွေးထွေးပြီး နေရောင်လို လင်းလက်တဲ့ အငွေ့အသက်ကို သယ်ဆောင်ထားတယ်။ တောက်ပရတာနဲ့ တခြားသူတွေကို အားပေးရတာ နှစ်သက်တယ်။ တိတ်ဆိတ်တဲ့နေ့တွေမှာတောင် ကိုယ်က လုံလောက်တယ်။';

  @override
  String get chartSunVirgo =>
      'စဉ်းစားပေးတတ်၊ ဂရုစိုက်တတ်ပြီး အသေးစိတ်တွေကိုလည်း သတိထားတတ်တယ်။ အရာရာ ပြည့်စုံမနေတဲ့အခါမှာတောင် ကိုယ့်ကိုယ်ကို ကြင်နာခွင့်ရှိတယ်။';

  @override
  String get chartSunLibra =>
      'သွားလေရာတိုင်းမှာ ဟန်ချက်ညီမှု၊ အလှအပနဲ့ နူးညံ့တဲ့ သဟဇာတဖြစ်မှုတွေကို ယူဆောင်လာတယ်။ ကိုယ့်လိုအပ်ချက်တွေကလည်း တခြားသူတွေရဲ့ လိုအပ်ချက်တွေလိုပဲ အရေးကြီးတယ်။';

  @override
  String get chartSunScorpio =>
      'အရာရာကို နက်နက်ရှိုင်းရှိုင်း ခံစားတတ်ပြီး အရင်းနှီးဆုံးသူတွေအပေါ် အလွန်သစ္စာရှိတယ်။ ကိုယ့်ရဲ့ ပြင်းထန်တဲ့စိတ်က အားသာချက်တစ်ခုပါ၊ အဆင်သင့်ဖြစ်တဲ့အခါ စိတ်ကို ပျော့ပျောင်းစေလို့ရတယ်။';

  @override
  String get chartSunSagittarius =>
      'စွန့်စားလိုစိတ်ရှိပြီး ရိုးသားကာ မျှော်လင့်ချက်တွေနဲ့ ပြည့်နေတယ်။ စူးစမ်းချင်စိတ်နောက်ကို လိုက်တဲ့အခါတိုင်း တိုးတက်လာတယ်။';

  @override
  String get chartSunCapricorn =>
      'စိတ်ရှည်၊ စိတ်ပိုင်းဖြတ်ထားပြီး အားကိုးရတယ်။ အနားယူလို့ရသလို ဒီအထိ ရောက်လာခဲ့တာအတွက်လည်း ဂုဏ်ယူလို့ရတယ်။';

  @override
  String get chartSunAquarius =>
      'ကိုယ်ပိုင်ထူးခြားမှုရှိပြီး ကြင်နာတတ်ကာ အိပ်မက်ဆန်ဆန်လေးလည်း ရှိတယ်။ အရာတွေကို ကိုယ်မြင်တဲ့ပုံစံကပဲ ကိုယ့်ကို ထူးခြားစေတာပါ။';

  @override
  String get chartSunPisces =>
      'နူးညံ့ပြီး စိတ်ကူးဉာဏ်ကြွယ်ကာ ကိုယ်ချင်းစာစိတ်လည်း အပြည့်ရှိတယ်။ ကိုယ့်အိပ်မက်တွေကို ကာကွယ်ဖို့ တန်ဖိုးရှိသလို ကိုယ့်စိတ်အေးချမ်းမှုကိုလည်း ကာကွယ်ဖို့ တန်ဖိုးရှိတယ်။';

  @override
  String get chartMoonAries =>
      'ခံစားချက်တွေက မြန်မြန်ဆန်ဆန် တောက်ပစွာ ရောက်လာတတ်တယ်။ အသက်ရှူဖို့ ခဏလောက် ကိုယ့်ကိုယ်ကို အချိန်ပေးပြီး နှလုံးသားကို သူ့အရှိန်နဲ့သူ သွားခွင့်ပေးပါ။';

  @override
  String get chartMoonTaurus =>
      'သက်တောင့်သက်သာနဲ့ အေးချမ်းမှုရှိတဲ့အခါ အလုံခြုံဆုံးလို့ ခံစားရတယ်။ အေးအေးဆေးဆေး လုပ်ရိုးလုပ်စဉ်လေးတွေ၊ အရသာရှိတဲ့အစားအစာနဲ့ နူးညံ့တဲ့အရာတွေက စိတ်ကို ငြိမ်သက်စေတယ်။';

  @override
  String get chartMoonGemini =>
      'စကားပြောတာ၊ စာရေးတာ ဒါမှမဟုတ် မျှဝေတာတွေက ကိုယ့်ခံစားချက်ကို နားလည်ဖို့ ကူညီပေးတယ်။ စိတ်အခြေအနေတွေက ကောင်းကင်လို ပြောင်းလဲနေရင်လည်း အဆင်ပြေပါတယ်။';

  @override
  String get chartMoonCancer =>
      'အရာရာကို နက်နက်ရှိုင်းရှိုင်း ခံစားတတ်ပြီး အိမ်က နှလုံးသား အနားယူရာနေရာပါ။ တခြားသူတွေကို ကြင်နာသလို ကိုယ့်ကိုယ်ကိုလည်း ကြင်နာပါ။';

  @override
  String get chartMoonLeo =>
      'ကိုယ့်နှလုံးသားက လူတွေမြင်ပြီး အသိအမှတ်ပြုပေးတာကို နှစ်သက်တယ်။ တခြားသူတွေဆီကရော ကိုယ့်ဆီကပါ ကြင်နာတဲ့စကားတွေကြောင့် ပိုတောက်ပလာတယ်။';

  @override
  String get chartMoonVirgo =>
      'အရာတွေ သပ်ရပ်ပြီး အသုံးဝင်တဲ့အခါ စိတ်အေးချမ်းတယ်။ စိုးရိမ်စရာအသေးအမွှားလေးတွေကို လွှတ်ချလို့ရတယ်၊ ကိုယ်လုပ်နေတာတွေ အဆင်ပြေနေပါတယ်။';

  @override
  String get chartMoonLibra =>
      'အရာတွေ ငြိမ်းချမ်းပြီး မျှတတဲ့အခါ အကောင်းဆုံးခံစားရတယ်။ ခက်ခဲသလို ခံစားရတဲ့အခါမှာတောင် ကိုယ်လိုအပ်တာကို ပြောလို့ရပါတယ်။';

  @override
  String get chartMoonScorpio =>
      'ခံစားချက်တွေက နက်ရှိုင်းပြီး ကိုယ်ပိုင်ဆန်တယ်။ ရင်ဖွင့်ဖို့ အချိန်ယူလို့ရသလို ကိုယ့်ယုံကြည်မှုကို ရယူထားသူတွေကိုလည်း ယုံကြည်ပါ။';

  @override
  String get chartMoonSagittarius =>
      'နေရာလွတ်နဲ့ မျှော်လင့်ချက်ရှိတဲ့အခါ လွတ်လပ်တယ်လို့ ခံစားရတယ်။ လမ်းလျှောက်တာ၊ ရယ်မောတာ ဒါမှမဟုတ် စွန့်စားမှုလေးတစ်ခုက စိတ်ကို လန်းဆန်းစေတယ်။';

  @override
  String get chartMoonCapricorn =>
      'ခံစားချက်တွေကို ရင်ထဲမှာပဲ သိမ်းထားပြီး တိတ်တိတ်လေး ဂရုစိုက်တတ်နိုင်တယ်။ နူးညံ့စွာ အနားယူတာက ကြိုးစားလုပ်ကိုင်တာနဲ့ ထပ်တူ အရေးကြီးပါတယ်။';

  @override
  String get chartMoonAquarius =>
      'ခံစားချက်တွေကို နောက်တစ်လှမ်းဆုတ်ပြီး စဉ်းစားကြည့်မှ နားလည်တတ်တယ်။ တိတ်ဆိတ်နေတဲ့အခါမှာတောင် နှလုံးသားက နွေးထွေးနေတယ်။';

  @override
  String get chartMoonPisces =>
      'စိတ်နှလုံးနူးညံ့ပြီး ကိုယ့်ပတ်ဝန်းကျင်က စိတ်ခံစားချက်တိုင်းကို အလွယ်တကူ ခံစားမိတတ်တယ်။ တိတ်တိတ်ဆိတ်ဆိတ် အချိန်ယူတာ၊ သီချင်းနားထောင်တာနဲ့ အိပ်မက်မက်တာတွေက အားပြန်ဖြည့်ပေးတယ်။';

  @override
  String get chartRisingAries =>
      'လူတွေက ကိုယ့်ကို ရဲရင့်တက်ကြွပြီး စလုပ်ဖို့ အဆင်သင့်ဖြစ်နေသူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ ယုံကြည်မှုက တခြားသူတွေကိုလည်း ရဲရင့်လာဖို့ အားပေးတယ်။';

  @override
  String get chartRisingTaurus =>
      'လူတွေက ကိုယ့်ကို တည်ငြိမ်ပြီး မြေပြင်နဲ့နီးစပ်ကာ နွေးထွေးသူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ တည်ငြိမ်တဲ့အရှိန်အဝါကြောင့် တခြားသူတွေလည်း စိတ်သက်သာရာရတယ်။';

  @override
  String get chartRisingGemini =>
      'လူတွေက ကိုယ့်ကို ထက်မြက်စူးစမ်းချင်စိတ်ရှိပြီး စကားပြောရလွယ်သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ တက်ကြွတဲ့စွမ်းအင်ကြောင့် အတူရှိရတာ ပျော်စရာကောင်းတယ်။';

  @override
  String get chartRisingCancer =>
      'လူတွေက ကိုယ့်ကို နူးညံ့ပြီး ဂရုစိုက်တတ်သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ ကြင်နာမှုကြောင့် တခြားသူတွေ အိမ်မှာရှိသလို နွေးထွေးလုံခြုံတယ်လို့ ခံစားရတယ်။';

  @override
  String get chartRisingLeo =>
      'လူတွေက ကိုယ့်ကို နွေးထွေးယုံကြည်မှုရှိပြီး တောက်ပလင်းလက်တဲ့သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရောက်လာတာနဲ့ အခန်းတစ်ခန်းလုံး လင်းလက်သွားသလိုပါပဲ။';

  @override
  String get chartRisingVirgo =>
      'လူတွေက ကိုယ့်ကို စဉ်းစားပေးတတ်၊ သပ်ရပ်ပြီး ကြင်နာတတ်သူလို့ မြင်နိုင်တယ်။ တိတ်တိတ်လေး ဂရုစိုက်ပေးတာက အသေးစိတ်လေးတွေမှာ ပေါ်လွင်နေတယ်။';

  @override
  String get chartRisingLibra =>
      'လူတွေက ကိုယ့်ကို တင့်တယ်ဖော်ရွေပြီး ပေါ့ပေါ့ပါးပါး နေတတ်သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ ဆွဲဆောင်မှုကြောင့် တခြားသူတွေကိုလည်း နွေးနွေးထွေးထွေး ကြိုဆိုခံရတယ်လို့ ခံစားရစေတယ်။';

  @override
  String get chartRisingScorpio =>
      'လူတွေက ကိုယ့်ကို တည်ငြိမ်ပြီး ဆွဲဆောင်မှုရှိကာ နည်းနည်းလျှို့ဝှက်ဆန်းကြယ်သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ နက်ရှိုင်းမှုကြောင့် တခြားသူတွေက ပိုသိချင်လာတယ်။';

  @override
  String get chartRisingSagittarius =>
      'လူတွေက ကိုယ့်ကို ပျော်ပျော်ရွှင်ရွှင်၊ ပွင့်လင်းပြီး စွန့်စားလိုစိတ်ရှိသူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ အကောင်းမြင်စိတ်က ကူးစက်လွယ်တယ်။';

  @override
  String get chartRisingCapricorn =>
      'လူတွေက ကိုယ့်ကို တည်တည်ငြိမ်ငြိမ်၊ စွမ်းဆောင်နိုင်ပြီး ဉာဏ်ပညာရှိသူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ တည်ငြိမ်တဲ့အာရုံစိုက်မှုက ယုံကြည်မှုကို ရစေတယ်။';

  @override
  String get chartRisingAquarius =>
      'လူတွေက ကိုယ့်ကို ထူးခြားဖော်ရွေပြီး ခန့်မှန်းရခက်တဲ့ပုံစံလေးရှိသူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ ကိုယ်ပိုင်ထူးခြားမှုက ချစ်စရာကောင်းတဲ့ပုံစံနဲ့ ပေါ်လွင်နေတယ်။';

  @override
  String get chartRisingPisces =>
      'လူတွေက ကိုယ့်ကို နူးညံ့အိပ်မက်ဆန်ပြီး ကြင်နာတတ်သူလို့ မြင်နိုင်တယ်။ ကိုယ့်ရဲ့ နူးညံ့တဲ့အငွေ့အသက်ကြောင့် တခြားသူတွေကို နားလည်ခံစားပေးခံရတယ်လို့ ခံစားရစေတယ်။';

  @override
  String get analyticsConsentTitle =>
      'Mochi Moon ကို ပိုတိုးတက်အောင် ကူညီမလား။';

  @override
  String get analyticsConsentBody =>
      'ကတ်ဘယ်နှစ်ကတ် ပြီးသွားလဲဆိုတာလို ရိုးရိုး tap အရေအတွက်လေးတွေကို ရေတွက်ပြီး app ကို ပိုနူးညံ့ပြီး ပိုကောင်းလာအောင် လုပ်ချင်ပါတယ်။ မွေးနေ့၊ ပါတနာတွေရဲ့နာမည်၊ ကိုယ့်မှတ်တမ်း ဒါမှမဟုတ် ကတ်ပေါ်ကစာတွေကို ဘယ်တော့မှ မမျှဝေပါဘူး။ ဒီအချက်ကို အချိန်မရွေး ကိုယ်တိုင်မှာ ပြောင်းနိုင်ပါတယ်။';

  @override
  String get analyticsConsentAllow => 'ဟုတ်ကဲ့၊ ငါ့ tap တွေကို ရေတွက်ပါ';

  @override
  String get analyticsConsentDecline => 'မလိုပါဘူး၊ ကျေးဇူးပါ';

  @override
  String get analyticsSettingTitle =>
      'အမည်မဖော်တဲ့ အသုံးပြုမှုအချက်အလက် မျှဝေမယ်';

  @override
  String get analyticsSettingSubtitle =>
      'ပြီးသွားတဲ့ကတ်အရေအတွက်လို ရိုးရိုးရေတွက်ချက်တွေပါ။ မွေးနေ့၊ နာမည်၊ မှတ်တမ်း ဒါမှမဟုတ် ကတ်ပေါ်ကစာတွေကို ဘယ်တော့မှ မပါဝင်ပါဘူး။';

  @override
  String get announcementsTitle => 'app သတင်းလေးတွေ';

  @override
  String get announcementsSubtitle =>
      'Mochi Moon မှာ အသစ်တစ်ခုခု ရောက်လာတဲ့အခါ တစ်ခါတလေ ပို့ပေးမယ့် မှတ်စုလေး';

  @override
  String get meAboutSubtitle =>
      'ဖတ်ရှုချက်တွေ ဘယ်လိုလုပ်ဆောင်လဲ၊ Open-source လိုင်စင်များ';

  @override
  String get aboutTitle => 'အကြောင်း';

  @override
  String get aboutReadingsTitle => 'ဖတ်ရှုချက်တွေအကြောင်း';

  @override
  String get aboutReadingsBody =>
      'ဒီမှာ ဖတ်ရှုရတာတွေအားလုံးက ဖျော်ဖြေရေးနဲ့ ကိုယ့်ကိုယ်ကို ပြန်လည်ဆင်ခြင်ဖို့အတွက်ပါ။ ကိုယ့်ခံစားချက်တွေကို သတိထားမိစေဖို့ နူးညံ့တဲ့ အကြံပြုချက်လေးတွေဖြစ်ပြီး ကိုယ့်နေ့ရက် ဒါမှမဟုတ် ဘဝက ဘယ်လိုဖြစ်ရမယ်ဆိုတဲ့ စည်းမျဉ်းတွေ မဟုတ်ပါဘူး။';

  @override
  String get aboutZodiacTitle => 'အသုံးပြုထားတဲ့ ရာသီခွင်စနစ်';

  @override
  String get aboutZodiacBody =>
      'Mochi Moon က အနောက်တိုင်း tropical zodiac စနစ်ကို အသုံးပြုထားပါတယ်။ မွေးနေ့ရက်အပေါ်မူတည်ပြီး Sun, Moon နဲ့ Rising sign တွေကို တွက်ချက်ထားပြီး Moon phase နဲ့ retrograde ရက်စွဲတွေကလည်း တကယ့်ကောင်းကင်အခြေအနေအတိုင်း ဖြစ်ပါတယ်။';

  @override
  String get aboutWritingTitle => 'ဖတ်ရှုချက်တွေကို ဘယ်လိုရေးထားလဲ';

  @override
  String get aboutWritingBody =>
      'နေ့စဉ်ဖတ်ရှုချက်တွေကို AI အကူအညီနဲ့ ကြိုတင်ရေးသားထားပြီး နူးညံ့အားပေးတဲ့ အသံနေအသံထားနဲ့ ရေးထားပါတယ်။ ဒီမှာ chat မရှိပါဘူး—ဘယ်သူမှ AI ကို မေးခွန်းတွေ ရိုက်မေးနေတာ မဟုတ်ပါဘူး။';

  @override
  String get aboutCareTitle => 'မပါဝင်စေထားတဲ့အရာတွေ';

  @override
  String get aboutCareBody =>
      'ဖတ်ရှုချက်တွေမှာ ကျန်းမာရေး၊ သေဆုံးမှု၊ ကိုယ်ဝန်၊ ငွေကြေး ဒါမှမဟုတ် ဥပဒေရေးရာ ရလဒ်တွေကို ဘယ်တော့မှ ကြိုဟောမှာမဟုတ်သလို၊ ဆက်ဆံရေးတစ်ခု အဆင်မပြေတော့ဘူး ဒါမှမဟုတ် အောင်မြင်မယ်လို့လည်း မပြောပါဘူး။ အဲဒီလိုကိစ္စတွေအတွက် ယုံကြည်ရတဲ့သူတစ်ယောက် ဒါမှမဟုတ် ကျွမ်းကျင်ပညာရှင်တစ်ယောက်နဲ့ ဆွေးနွေးပါနော်။';

  @override
  String get aboutLicenses => 'Open-source လိုင်စင်များ';

  @override
  String get mePartnersSubtitle =>
      'ကိုယ့် birth chart နဲ့ နှိုင်းယှဉ်ကြည့်တဲ့သူတွေ';

  @override
  String get partnersTitle => 'ပါတနာများ';

  @override
  String get partnersEmptyTitle => 'ပါတနာ မရှိသေးဘူး';

  @override
  String get partnersEmptyBody =>
      'birth chart တွေ ဘယ်လိုလိုက်ဖက်လဲ ကြည့်ဖို့ တစ်ယောက်ယောက်ရဲ့ မွေးနေ့ကို ထည့်လိုက်ပါ။ ပျော်ဖို့နဲ့ ကိုယ့်ကိုယ်ကို ပြန်လည်ဆင်ခြင်ဖို့ သက်သက်ပါ။';

  @override
  String get partnersAdd => 'ပါတနာ ထည့်မယ်';

  @override
  String partnersLimitFree(int free, int premium) {
    return 'Free မှာ partner $free ယောက် ပါဝင်ပါတယ်။ Premium မှာတော့ $premium ယောက်အထိ သိမ်းထားနိုင်ပါတယ်။';
  }

  @override
  String partnersLimitPremium(int count) {
    return 'သိမ်းထားနိုင်တဲ့ အများဆုံး partner အရေအတွက် ($count) ပြည့်သွားပါပြီ။ အသစ်တစ်ယောက် ထည့်ဖို့ တစ်ယောက်ကို ဖျက်လိုက်ပါ။';
  }

  @override
  String partnersTileSubtitle(String sign, String date) {
    return '$sign · မွေးနေ့ $date';
  }

  @override
  String partnersDeleteTooltip(String name) {
    return '$name ကို ဖျက်မယ်';
  }

  @override
  String partnersDeleteTitle(String name) {
    return '$name ကို ဖျက်မှာလား။';
  }

  @override
  String get partnersDeleteBody =>
      'သူ့ရဲ့ မွေးဖွားမှုအချက်အလက်တွေကို ဒီဖုန်းနဲ့ ကိုယ့်အကောင့်ထဲကနေ ဖယ်ရှားပါမယ်။ အချိန်မရွေး ပြန်ထည့်နိုင်ပါတယ်။';

  @override
  String get partnersDeleteConfirm => 'ဖျက်မယ်';

  @override
  String get partnersAddTitle => 'ပါတနာ ထည့်မယ်';

  @override
  String get partnersEditTitle => 'ပါတနာကို ပြင်မယ်';

  @override
  String get partnersNicknameLabel => 'ချစ်စနိုးနာမည်';

  @override
  String get partnersNicknameHelper =>
      'ချစ်စနိုးနာမည်လေးဆို အဆင်ပြေပါတယ်။ ကိုယ်တစ်ယောက်တည်းပဲ မြင်နိုင်ပါတယ်။';

  @override
  String get partnersBirthDateLabel => 'မွေးနေ့';

  @override
  String get partnersBirthDateChoose => 'ရက်စွဲရွေးပါ';

  @override
  String get partnersBirthTimeLabel => 'မွေးချိန် (မဖြည့်လည်းရပါတယ်)';

  @override
  String get partnersBirthPlaceLabel => 'မွေးဖွားရာနေရာ (မဖြည့်လည်းရပါတယ်)';

  @override
  String get partnersBirthPlaceNeeded =>
      'မွေးချိန်ကို မှန်ကန်တဲ့ time zone နဲ့ ဖတ်ရှုနိုင်ဖို့ မွေးဖွားရာနေရာကို ထည့်ပေးပါ။';

  @override
  String get partnersLightHint =>
      'မွေးချိန်မရှိရင် အခြေခံဖတ်ရှုချက်လေးကို ရပါမယ်။ ဒါလေးလည်း ကောင်းပါတယ်။';

  @override
  String get partnersPrivacy =>
      'ဒါကို ကိုယ်တစ်ယောက်တည်းပဲ မြင်နိုင်ပြီး အချိန်မရွေး ဖျက်နိုင်ပါတယ်။';

  @override
  String get partnersSave => 'သိမ်းမယ်';

  @override
  String get partnersSaveFailed =>
      'ဒါကို သိမ်းလို့မရပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get partnersLimitReached => 'ပါတနာ အများဆုံးအရေအတွက် ပြည့်သွားပါပြီ။';

  @override
  String get partnersNotFound => 'ဒီပါတနာကို ရှာမတွေ့ပါဘူး။';

  @override
  String partnersEditTooltip(String name) {
    return '$name ကို ပြင်မယ်';
  }

  @override
  String get compatTitle => 'လိုက်ဖက်မှု';

  @override
  String get compatNeedsBirthDateTitle => 'နှိုင်းယှဉ်ဖို့ မွေးနေ့ထည့်ပါ';

  @override
  String get compatNeedsBirthDateBody =>
      'ကိုယ့် birth chart နဲ့ သူ့ birth chart ဘယ်လိုဆုံစည်းလဲ ဖတ်ဖို့ ကိုယ့်မွေးနေ့ရက် လိုပါတယ်။';

  @override
  String compatHeader(String yourSign, String name, String theirSign) {
    return 'ကိုယ် ($yourSign) + $name ($theirSign)';
  }

  @override
  String compatMeterLabel(int score) {
    return 'လိုက်ဖက်မှု $score ရာခိုင်နှုန်း';
  }

  @override
  String get compatSummaryLow =>
      'အတူတူ ကြီးထွားဖို့ အခွင့်အရေးများတဲ့ နူးညံ့တဲ့ လိုက်ဖက်မှုလေးပါ။';

  @override
  String get compatSummaryMid =>
      'အေးအေးဆေးဆေး သက်တောင့်သက်သာရှိတဲ့ အခိုက်အတန့်လေးတွေ ပါဝင်တဲ့ နွေးထွေးတဲ့ လိုက်ဖက်မှုလေးပါ။';

  @override
  String get compatSummaryHigh =>
      'birth chart တွေ အတူတူ တကယ်လိုက်ဖက်ညီစွာ တောက်ပနေတဲ့ လိုက်ဖက်မှုလေးပါ။';

  @override
  String get compatLightLabel => 'အခြေခံဖတ်ရှုချက်';

  @override
  String get compatLightBody =>
      'နှစ်ယောက်လုံးရဲ့ မွေးချိန်မရှိတဲ့အတွက် ဒီဖတ်ရှုချက်က အခြေခံပုံစံလေးပါ။ မွေးချိန်နဲ့ မွေးဖွားရာနေရာ ထည့်ပေးရင် ပိုပြည့်စုံလာမယ်။';

  @override
  String get compatThemeRomance => 'အချစ်ရေး';

  @override
  String get compatThemeEmotional => 'စိတ်ခံစားမှု';

  @override
  String get compatThemeCommunication => 'ဆက်သွယ်ပြောဆိုမှု';

  @override
  String compatThemeScore(String theme, int score) {
    return '$theme $score ရာခိုင်နှုန်း';
  }

  @override
  String get compatFlowTitle => 'အဆင်ပြေချောမွေ့တဲ့အရာတွေ';

  @override
  String get compatGrowTitle => 'အတူတူ ကြီးထွားနိုင်မယ့်နေရာတွေ';

  @override
  String get compatQuiet =>
      'ကိုယ့် birth chart တွေကြားမှာ ထူးထူးခြားခြား မတွေ့ရလည်း အဆင်ပြေပါတယ်။ ဆက်ဆံရေးတိုင်းမှာ ကိုယ်ပိုင်စည်းချက်လေးတွေ ရှိတတ်ပါတယ်။';

  @override
  String compatAspectPair(String yours, String name, String theirs) {
    return 'ကိုယ့် $yours + $name ရဲ့ $theirs';
  }

  @override
  String get compatAspectConjunction =>
      'ဒီနှစ်ခုက အတူတူ လိုက်ဖက်နေတဲ့အတွက် ကိုယ့်ရဲ့ ဒီအပိုင်းလေးက သဘာဝအတိုင်း နီးစပ်တယ်လို့ ခံစားရစေပါတယ်။';

  @override
  String get compatAspectSextile =>
      'ဒီနှစ်ခုက အဆင်ပြေပြေ ပူးပေါင်းနိုင်ပြီး တစ်ယောက်နဲ့တစ်ယောက် အပြန်အလှန် အားဖြည့်ပေးတတ်ပါတယ်။';

  @override
  String get compatAspectTrine =>
      'ဒီနှစ်ခုက အားစိုက်စရာမလိုဘဲ နွေးနွေးထွေးထွေး အဆင်ပြေပြေ စီးဆင်းနေပါတယ်။';

  @override
  String get compatAspectSquare =>
      'ဒီနှစ်ခုကြားမှာ တောက်ပတဲ့ဆွဲအားလေးရှိပြီး စိတ်ရှည်မှုနဲ့ နားလည်ပေးမှုကို တောင်းဆိုတတ်ပါတယ်။';

  @override
  String get compatAspectOpposition =>
      'ဒီနှစ်ခုက ဦးတည်ရာမတူဘဲ ဆွဲခေါ်တတ်တာကြောင့် ဟန်ချက်ညီအောင်နေခြင်းနဲ့ နားထောင်ပေးခြင်းက အထောက်အကူဖြစ်ပါတယ်။';

  @override
  String get meProfileTitle => 'ပရိုဖိုင်ကို ပြင်မယ်';

  @override
  String get meProfileSubtitle => 'နာမည်၊ မွေးနေ့နဲ့ အာရုံစိုက်ချင်တဲ့အရာတွေ';

  @override
  String get profileEditTitle => 'ပရိုဖိုင်ကို ပြင်မယ်';

  @override
  String get profileEditBirthDateLabel => 'မွေးနေ့';

  @override
  String get profileEditBirthDateChoose => 'ရက်စွဲရွေးပါ';

  @override
  String get profileEditBirthTimeLabel => 'မွေးချိန် (မဖြည့်လည်းရပါတယ်)';

  @override
  String get profileEditBirthPlaceLabel => 'မွေးဖွားရာနေရာ';

  @override
  String get profileEditBirthPlaceNeeded =>
      'မွေးချိန်ကို မှန်ကန်တဲ့ time zone နဲ့ ဖတ်ရှုနိုင်ဖို့ မွေးဖွားရာနေရာကို ထည့်ပေးပါ။';

  @override
  String get profileEditFocusLabel => 'ပိုပြီး ရချင်တဲ့အရာတွေ';

  @override
  String get profileEditNote =>
      'မွေးဖွားမှုအချက်အလက်တွေ ပြောင်းလိုက်ရင် birth chart၊ ဖတ်ရှုချက်တွေနဲ့ compatibility ရလဒ်တွေပါ ပြောင်းလဲသွားပါမယ်။';

  @override
  String get profileEditSave => 'သိမ်းမယ်';

  @override
  String get profileEditSaved => 'ပရိုဖိုင်ကို ပြင်ဆင်ပြီးပါပြီ။';
}
