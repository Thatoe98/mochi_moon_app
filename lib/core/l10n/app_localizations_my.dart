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
  String get tabDeck => 'ကတ်များ';

  @override
  String get tabCosmic => 'စကြဝဠာ';

  @override
  String get tabMe => 'ကိုယ်တိုင်';

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
  String get cosmicNeedsBirthDateTitle => 'မွေးနေ့ရက်လေး လိုနေတယ်';

  @override
  String get cosmicNeedsBirthDateBody =>
      'မွေးနေ့ရက်ကို မျှဝေပေးရင် နေ့စဉ်လမ်းညွှန်ချက်လေးတွေ ဒီမှာ ပေါ်လာမယ်။';

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
  String get thaiColorsSettingTitle => 'ထိုင်းရိုးရာ နေ့အလိုက်အရောင်များ';

  @override
  String get thaiColorsSettingSubtitle =>
      'ကိုယ့်ရဲ့ စကြဝဠာမှာ မွေးနေ့အရောင်နဲ့ ဒီနေ့အရောင်ကို ပြမယ်';

  @override
  String get languageTitle => 'ဘာသာစကား';

  @override
  String get languageSystem => 'ဖုန်းမှာ သတ်မှတ်ထားတဲ့ ဘာသာစကားအတိုင်း';

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
}
