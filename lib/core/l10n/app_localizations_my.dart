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
  String get deckIllustrationSemantics => 'နူးညံ့သော လပုံ ပုံဆွဲ';

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
  String get cosmicPlaceholderTitle => 'သင့်စကြဝဠာ';

  @override
  String get cosmicPlaceholderBody => 'သင့်ကြယ်များ ပြင်ဆင်နေပါသည်။';

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
}
