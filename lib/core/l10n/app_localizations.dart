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

  /// No description provided for @deckPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your self-love deck'**
  String get deckPlaceholderTitle;

  /// No description provided for @deckPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Soft little reminders are on their way.'**
  String get deckPlaceholderBody;

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

  /// No description provided for @mePlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Your journal and settings will live here.'**
  String get mePlaceholderBody;

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
