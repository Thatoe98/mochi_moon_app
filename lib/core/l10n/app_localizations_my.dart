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
  String get tabMe => 'ကျွန်မ';

  @override
  String get deckTitle => 'ကိုယ့်ကိုယ်ကိုယ် ချစ်ခြင်း ကတ်များ';

  @override
  String get deckEmptyBody => 'နူးညံ့သော သတိပေးစကားလေးများ လာနေပါပြီ။';

  @override
  String deckStreakSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ဆက်တိုက် $count ရက်',
    );
    return '$_temp0';
  }

  @override
  String deckCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ယနေ့ ကတ် $count ကတ် ကျန်ပါသေးသည်',
    );
    return '$_temp0';
  }

  @override
  String get deckLimitTitle => 'သင်တောက်ပနေပါပြီ ✨';

  @override
  String get deckLimitBody =>
      'ယနေ့ကတ်များ ပြီးဆုံးပါပြီ။ နောက်ထပ်ကတ်များအတွက် မနက်ဖြန် ပြန်လာခဲ့ပါ။';

  @override
  String get deckActionSkip => 'နောက်ကတ်';

  @override
  String get deckActionSave => 'ဒါ ကျွန်မပါ';

  @override
  String get deckActionShare => 'မျှဝေမည်';

  @override
  String get deckActionUndo => 'နောက်ပြန်';

  @override
  String get deckTimerSemantics => 'အသံထွက်ဖတ်ချိန် တိုင်မာ';

  @override
  String get deckTimerReady => 'ပွတ်ဆွဲနိုင်ပါပြီ';

  @override
  String get shareFailed => 'မျှဝေရန် မဖွင့်နိုင်ပါ။ ထပ်မံကြိုးစားကြည့်ပါ။';

  @override
  String get categorySelfLove => 'ကိုယ့်ကိုယ်ကိုယ် ချစ်ခြင်း';

  @override
  String get categoryConfidence => 'ယုံကြည်မှု';

  @override
  String get categoryHealing => 'ကုစားခြင်း';

  @override
  String get categoryStudyWork => 'ပညာရေးနှင့် အလုပ်';

  @override
  String get categoryBodyKindness => 'ကိုယ်ခန္ဓာကို ကြင်နာခြင်း';

  @override
  String get categoryCalm => 'ငြိမ်သက်ခြင်း';

  @override
  String get cosmicTitle => 'သင့်စကြဝဠာ';

  @override
  String get mePlaceholderTitle => 'သင်တစ်ယောက်တည်း';

  @override
  String get journalTitle => 'ကျွန်မ၏ မှတ်တမ်း';

  @override
  String get meJournalSubtitle => 'ကျွန်မနှင့် တူသော ကတ်များ';

  @override
  String get journalEmptyTitle => 'ဘာမှ မသိမ်းရသေးပါ';

  @override
  String get journalEmptyBody =>
      'ကြိုက်သော ကတ်များကို ညာဘက်သို့ ပွတ်ဆွဲပါ။ ဤနေရာတွင် သိမ်းထားပါမည်။';

  @override
  String get journalFilterAll => 'အားလုံး';

  @override
  String get journalRemoveTitle => 'မှတ်တမ်းမှ ဖယ်ရှားမလား။';

  @override
  String get journalRemoveBody =>
      'ဤကတ်သည် မှတ်တမ်းမှ ထွက်သွားပါမည်။ နောက်မှ ပြန်သိမ်းနိုင်ပါသည်။';

  @override
  String get journalRemoveConfirm => 'ဖယ်ရှားမည်';

  @override
  String get journalKeep => 'ဆက်သိမ်းမည်';

  @override
  String get journalClose => 'ပိတ်မည်';

  @override
  String get reminderTitle => 'နေ့စဉ် သတိပေးချက်';

  @override
  String get reminderSubtitle => 'သတိပေးချက်တွင် နူးညံ့သော ကတ်တစ်ကတ်';

  @override
  String get reminderTimeLabel => 'သတိပေးချိန်';

  @override
  String get reminderPrePromptTitle =>
      'နေ့စဉ် နူးညံ့သော သတိပေးချက် လိုချင်ပါသလား။';

  @override
  String get reminderPrePromptBody =>
      'Mochi Moon က သင်ရွေးသော အချိန်တွင် တစ်ရက်လျှင် ကတ်တစ်ကတ် ပို့ပေးနိုင်ပါသည်။ ထိုသို့ပြုရန် သင့်ဖုန်းက အသိပေးချက်များ ခွင့်ပြုရန် မေးပါမည်။';

  @override
  String get reminderPrePromptAllow => 'ကောင်းပါပြီ';

  @override
  String get reminderPrePromptLater => 'ယခု မလိုပါ';

  @override
  String get reminderPermissionDenied =>
      'Mochi Moon အတွက် အသိပေးချက်များ ပိတ်ထားပါသည်။ ဖုန်း၏ ဆက်တင်များတွင် ဖွင့်နိုင်ပါသည်။';

  @override
  String get reminderNotificationTitle => 'သင့် Mochi Moon ကတ် ✨';

  @override
  String get reminderChannelName => 'နေ့စဉ် သတိပေးချက်';

  @override
  String get reminderChannelDescription =>
      'သင်ရွေးသော အချိန်တွင် နေ့စဉ် နူးညံ့သော ကတ်တစ်ကတ်။';

  @override
  String get onboardingWelcomeTitle => 'Mochi Moon မှ ကြိုဆိုပါတယ်';

  @override
  String get onboardingWelcomeBody =>
      'သင်ဟာ ဘယ်လောက်အံ့ဩစရာကောင်းတဲ့သူလဲဆိုတာ သတိရစေမယ့် နူးညံ့တဲ့ ကတ်လေးတွေပါ။ ကတ်တစ်ကတ်စီကို အသံထွက်ဖတ်ပြီး အဲဒီစကားလေးတွေကို စိတ်ထဲမှာ ခံစားကြည့်ပါ။';

  @override
  String onboardingTryCards(int count) {
    return 'ကတ် $count ကတ်ကို စမ်းကြည့်ပါ';
  }

  @override
  String onboardingCardProgress(int current, int total) {
    return 'ကတ် $current / $total';
  }

  @override
  String get onboardingSaveTitle =>
      'သင့်ကတ်တွေကို သိမ်းပြီး စကြဝဠာဖတ်ရှုချက် ရယူလိုက်ပါ';

  @override
  String get onboardingSaveBody =>
      'သင်နှစ်သက်တဲ့ ကတ်တွေကို မှတ်တမ်းထဲမှာ စောင့်နေပါတယ်။ သင့်စကြဝဠာဖတ်ရှုချက်လည်း မကြာခင် ရောက်လာတော့မှာပါ။';

  @override
  String get onboardingContinue => 'ဆက်လုပ်မယ်';

  @override
  String get readAloudHint => 'အသံထွက်ဖတ်ပါ ✨';

  @override
  String get entertainmentNote =>
      'ဖျော်ဖြေရေးနှင့် ကိုယ်ကိုယ်ပြန်စဉ်းစားရန်အတွက်သာ';

  @override
  String get stateLoading => 'မှော်ပညာလေး စုနေပါသည်…';

  @override
  String get stateErrorTitle => 'တစ်ခုခု မှားသွားပါသည်';

  @override
  String get stateErrorBody => 'ထပ်ကြိုးစားကြည့်ကြစို့။';

  @override
  String get stateRetry => 'ထပ်ကြိုးစားမည်';

  @override
  String get stateOffline =>
      'အော့ဖ်လိုင်းဖြစ်နေပါသည်။ သိမ်းထားသည့်အရာများကို ပြထားပါသည်။';

  @override
  String get stateEmptyTitle => 'ဤနေရာတွင် မရှိသေးပါ';

  @override
  String get illustrationOnboardingWelcome =>
      'လာဗင်ဒါရောင် ညကောင်းကင်ထဲက တောက်ပနေတဲ့ လခြမ်းပေါ်မှာ လက်ပြနှုတ်ဆက်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationOnboardingSave =>
      'တောက်ပနေတဲ့ ကတ်လေးတွေ စုပုံကို ဖက်ထားတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationEmptyDeck =>
      'အိပ်ချင်နေတဲ့ လခြမ်းပေါ်မှာ ထိုင်ပြီး တောက်ပနေတဲ့ နှလုံးသားလေးကို ကြည့်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationCalm =>
      'လွင့်မျောနေတဲ့ ပန်းဖတ်လေးတွေနဲ့ ကြယ်တွေအကြားမှာ မျက်လုံးမှိတ်ပြီး ငြိမ်းငြိမ်းချမ်းချမ်း ထိုင်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationConfidence =>
      'တောက်ပနေတဲ့ လခြမ်းပေါ်မှာ လက်ကို တင်ပါးပေါ်တင်ပြီး ဂုဏ်ယူစွာ မတ်တပ်ရပ်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationHealing =>
      'ကြယ်လေးတွေပါတဲ့ စောင်ခြုံထားပြီး လက်ဖက်ရည်ပူပူတစ်ခွက်ကို ပြုံးရင်း ကိုင်ထားတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationSelfWorth =>
      'တောက်ပနေတဲ့ နှလုံးသားလေးကို ပြထားတဲ့ လက်ကိုင်မှန်လေးကို ကိုင်ထားတဲ့ လယုန်လေး Mochi';

  @override
  String get illustrationRest =>
      'လခြမ်းအောက်က နူးညံ့တဲ့ တိမ်ပေါ်မှာ အိပ်ပျော်နေတဲ့ လယုန်လေး Mochi';

  @override
  String get signInGoogle => 'Google နဲ့ ဆက်လုပ်မယ်';

  @override
  String get signInFailed => 'ဝင်လို့မရပါဘူး။ ထပ်စမ်းကြည့်ပါနော်။';

  @override
  String get signInOffline =>
      'အင်တာနက်ချိတ်ဆက်မှု မရှိသလိုပါပဲ။ ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်စမ်းကြည့်ပါနော်။';

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
      'နာမည်အရင်း ဒါမှမဟုတ် ချစ်စနိုးနာမည်လေး ပေးလို့ရပါတယ်။';

  @override
  String get profileNameLabel => 'သင့်နာမည်';

  @override
  String get profileBirthDateTitle => 'မွေးနေ့က ဘယ်နေ့လဲ။';

  @override
  String get profileBirthDateBody =>
      'သင့်နေရာသီခွင်နဲ့ စကြဝဠာဖတ်ရှုချက်တို့ရဲ့ အစက ဒီမှာပါ။';

  @override
  String profileBirthDateChosen(String date) {
    return 'မွေးနေ့ $date';
  }

  @override
  String get profileBirthTimeTitle => 'ဘယ်အချိန်မှာ မွေးဖွားခဲ့တာလဲ။';

  @override
  String get profileBirthTimeBody =>
      'ဒါက မဖြစ်မနေ မဟုတ်ပါဘူး။ မွေးချိန်သိရင် လရာသီခွင်နဲ့ အတက်ရာသီခွင်ကို ပိုတိကျစေပါတယ်။';

  @override
  String get profileBirthTimeChoose => 'အချိန်ရွေးမယ်';

  @override
  String get profileBirthTimeChange => 'အချိန်ပြောင်းမယ်';

  @override
  String get profileBirthTimeUnknown => 'မသိပါဘူး';

  @override
  String profileBirthTimeChosen(String time) {
    return '$time မှာ မွေးဖွားခဲ့ပါတယ်';
  }

  @override
  String get profileBirthTimeNone => 'မွေးချိန်မသိလည်း ရပါတယ်။';

  @override
  String get profileBirthPlaceTitle => 'ဘယ်နေရာမှာ မွေးဖွားခဲ့တာလဲ။';

  @override
  String get profileBirthPlaceBodyRequired =>
      'ဒီနေရာရဲ့ အချိန်ဇုန်အတိုင်း သင့်မွေးချိန်ကို တွက်ချက်ပေးမှာပါ။';

  @override
  String get profileBirthPlaceBodyOptional =>
      'မဖြစ်မနေ မဟုတ်ပါဘူး။ အနီးဆုံးမြို့ကို ရှာပါ၊ ဒါမှမဟုတ် ကျော်သွားလို့ရပါတယ်။';

  @override
  String get profileBirthPlaceLabel => 'မြို့တစ်မြို့ ရှာပါ';

  @override
  String get profileBirthPlaceNoMatches =>
      'နေရာမတွေ့ပါဘူး။ အနီးအနားက မြို့ကြီးတစ်မြို့ကို ရှာကြည့်ပါ။';

  @override
  String get profileBirthPlaceLoadFailed => 'နေရာစာရင်းကို ရယူလို့မရပါဘူး။';

  @override
  String profileBirthPlaceChosen(String place) {
    return '$place မှာ မွေးဖွားခဲ့ပါတယ်';
  }

  @override
  String get profileBirthPlaceChange => 'တခြားနေရာတစ်ခု ရွေးမယ်';

  @override
  String get profileReminderTitle => 'နေ့စဉ် သတိပေးချက်လေး လိုချင်လား။';

  @override
  String get profileReminderBody =>
      'တစ်နေ့ကို နူးညံ့တဲ့ ကတ်လေးတစ်ကတ်ပါ။ အချိန်မရွေး ပြောင်းလို့ရပါတယ်။';

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
  String get profileFocusTitle => 'ဘယ်အရာတွေကို ပိုလိုချင်လဲ။';

  @override
  String profileFocusBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ခုအထိ ရွေးပါ။',
    );
    return '$_temp0';
  }

  @override
  String get profileFinish => 'စလိုက်ကြစို့';

  @override
  String get profileSaveFailed =>
      'သိမ်းဆည်းလို့ မရပါဘူး။ ထပ်ကြိုးစားကြည့်ပါနော်။';

  @override
  String get cosmicNeedsBirthDateTitle =>
      'သင့်ကြယ်တွေအတွက် မွေးနေ့ရက်စွဲလေး လိုပါတယ်';

  @override
  String get cosmicNeedsBirthDateBody =>
      'မွေးနေ့ရက်စွဲလေးကို မျှဝေပေးရင် နေ့စဉ်လမ်းညွှန်ချက်လေးကို ဒီမှာ ဖော်ပြပေးပါမယ်။';

  @override
  String cosmicHeader(String sign, String date) {
    return '$sign · $date ရက်နေ့';
  }

  @override
  String cosmicMoonIn(String sign) {
    return 'လ $sign မှာ';
  }

  @override
  String get cosmicEnergyTitle => 'ဒီနေ့ရဲ့ စွမ်းအင်';

  @override
  String get cosmicLoveTitle => 'အချစ်';

  @override
  String get cosmicLuckyColorsTitle => 'ကံကောင်းစေမယ့် အရောင်များ';

  @override
  String get cosmicLuckyNumberTitle => 'ကံကောင်းစေမယ့် ဂဏန်း';

  @override
  String get cosmicAvoidTitle => 'ရှောင်သင့်တာများ';

  @override
  String get cosmicThaiColorsTitle => 'ထိုင်းရိုးရာ အရောင်များ';

  @override
  String get cosmicThaiBirthdayColor => 'သင့်မွေးနေ့အရောင်';

  @override
  String get cosmicThaiTodayColor => 'ဒီနေ့ရဲ့ အရောင်';

  @override
  String get cosmicDisclaimer =>
      'ဖျော်ဖြေရေးနှင့် ကိုယ်ကိုယ်ပြန်စဉ်းစားရန်အတွက်သာ';

  @override
  String get thaiColorsSettingTitle => 'ထိုင်းရိုးရာ နေ့အလိုက် အရောင်များ';

  @override
  String get thaiColorsSettingSubtitle =>
      'သင့်စကြဝဠာမှာ မွေးနေ့အရောင်နဲ့ ဒီနေ့ရဲ့အရောင်ကို ပြပါ';

  @override
  String get signAries => 'မိဿရာသီ';

  @override
  String get signTaurus => 'ပြိဿရာသီ';

  @override
  String get signGemini => 'မေထုန်ရာသီ';

  @override
  String get signCancer => 'ကရကဋ်ရာသီ';

  @override
  String get signLeo => 'သိဟ်ရာသီ';

  @override
  String get signVirgo => 'ကန်ရာသီ';

  @override
  String get signLibra => 'တူရာသီ';

  @override
  String get signScorpio => 'ဗြိစ္ဆာရာသီ';

  @override
  String get signSagittarius => 'ဓနုရာသီ';

  @override
  String get signCapricorn => 'မကာရရာသီ';

  @override
  String get signAquarius => 'ကုမ်ရာသီ';

  @override
  String get signPisces => 'မိန်ရာသီ';
}
