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
  String get mePlaceholderBody =>
      'သင့်မှတ်တမ်းနှင့် ဆက်တင်များ ဤနေရာတွင် ရှိပါမည်။';

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
