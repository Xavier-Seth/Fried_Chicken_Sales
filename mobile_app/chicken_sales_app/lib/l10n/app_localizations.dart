import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

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
    Locale('fil'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Chicken Sales Calculator'**
  String get appTitle;

  /// No description provided for @navSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get navSales;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get navCharts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @salesAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Sales'**
  String get salesAppBarTitle;

  /// No description provided for @historyAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get historyAppBarTitle;

  /// No description provided for @historyOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Overview'**
  String get historyOverviewTitle;

  /// No description provided for @historyDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 days} =1{1 day} other{{count} days}}'**
  String historyDaysCount(int count);

  /// No description provided for @historySummaryNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get historySummaryNet;

  /// No description provided for @historySummaryGross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get historySummaryGross;

  /// No description provided for @historySummaryTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get historySummaryTicket;

  /// No description provided for @historyRowGross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get historyRowGross;

  /// No description provided for @historyRowTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get historyRowTicket;

  /// No description provided for @historyRowNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get historyRowNet;

  /// No description provided for @historyRowExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get historyRowExpected;

  /// No description provided for @historyRowActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get historyRowActual;

  /// No description provided for @historyStatusShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get historyStatusShort;

  /// No description provided for @historyStatusOver.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get historyStatusOver;

  /// No description provided for @historyStatusMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get historyStatusMatch;

  /// No description provided for @historyDeleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete record?'**
  String get historyDeleteRecordTitle;

  /// No description provided for @historyDeleteRecordMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete saved record for {date}?'**
  String historyDeleteRecordMessage(Object date);

  /// No description provided for @historyDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all history?'**
  String get historyDeleteAllTitle;

  /// No description provided for @historyDeleteAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all saved records permanently.'**
  String get historyDeleteAllMessage;

  /// No description provided for @historyDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get historyDeleteAllConfirm;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get historyEmptyTitle;

  /// No description provided for @chartsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Charts'**
  String get chartsAppBarTitle;

  /// No description provided for @chartsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Chart Overview'**
  String get chartsHeroTitle;

  /// No description provided for @chartsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Net sales for the latest saved days.'**
  String get chartsHeroSubtitle;

  /// No description provided for @chartsDaysSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 days} =1{1 day} other{{count} days}}'**
  String chartsDaysSaved(int count);

  /// No description provided for @chartsHighestNet.
  ///
  /// In en, this message translates to:
  /// **'Highest Net'**
  String get chartsHighestNet;

  /// No description provided for @chartsTotalNet.
  ///
  /// In en, this message translates to:
  /// **'Total Net'**
  String get chartsTotalNet;

  /// No description provided for @chartsGross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get chartsGross;

  /// No description provided for @chartsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get chartsSaved;

  /// No description provided for @chartsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No chart data yet'**
  String get chartsEmptyTitle;

  /// No description provided for @chartsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save daily sales from the Sales tab to generate chart data.'**
  String get chartsEmptySubtitle;

  /// No description provided for @chartsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get chartsRefresh;

  /// No description provided for @chartsNetSalesChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Net Sales Chart'**
  String get chartsNetSalesChartTitle;

  /// No description provided for @chartsLastSavedDays.
  ///
  /// In en, this message translates to:
  /// **'Last {count} saved day(s)'**
  String chartsLastSavedDays(int count);

  /// No description provided for @settingsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsAppBarTitle;

  /// No description provided for @settingsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Settings'**
  String get settingsHeroTitle;

  /// No description provided for @settingsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update language and product prices here.'**
  String get settingsHeroSubtitle;

  /// No description provided for @settingsLanguageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSectionTitle;

  /// No description provided for @settingsLanguageSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used by the app interface.'**
  String get settingsLanguageSectionSubtitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageFilipino.
  ///
  /// In en, this message translates to:
  /// **'Filipino'**
  String get settingsLanguageFilipino;

  /// No description provided for @settingsLanguageEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use English across the app.'**
  String get settingsLanguageEnglishSubtitle;

  /// No description provided for @settingsLanguageFilipinoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use Filipino across the app.'**
  String get settingsLanguageFilipinoSubtitle;

  /// No description provided for @settingsLanguageSaved.
  ///
  /// In en, this message translates to:
  /// **'Language updated successfully.'**
  String get settingsLanguageSaved;

  /// No description provided for @settingsProductPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Prices'**
  String get settingsProductPricesTitle;

  /// No description provided for @settingsProductPricesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These values will be used in Sales, History, and Charts.'**
  String get settingsProductPricesSubtitle;

  /// No description provided for @settingsChickenLargePrice.
  ///
  /// In en, this message translates to:
  /// **'Chicken Large Price'**
  String get settingsChickenLargePrice;

  /// No description provided for @settingsChickenSmallPrice.
  ///
  /// In en, this message translates to:
  /// **'Chicken Small Price'**
  String get settingsChickenSmallPrice;

  /// No description provided for @settingsLumpiaPrice.
  ///
  /// In en, this message translates to:
  /// **'Lumpia Price'**
  String get settingsLumpiaPrice;

  /// No description provided for @settingsRicePrice.
  ///
  /// In en, this message translates to:
  /// **'Rice Price'**
  String get settingsRicePrice;

  /// No description provided for @settingsDefaultPrice.
  ///
  /// In en, this message translates to:
  /// **'Default: {value}'**
  String settingsDefaultPrice(Object value);

  /// No description provided for @settingsResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset Defaults'**
  String get settingsResetDefaults;

  /// No description provided for @settingsSaveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get settingsSaveSettings;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get settingsSavedSuccessfully;

  /// No description provided for @settingsResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to default values.'**
  String get settingsResetSuccessfully;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @salesHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Chicken Sales POS'**
  String get salesHeroTitle;

  /// No description provided for @salesBusinessDate.
  ///
  /// In en, this message translates to:
  /// **'Business Date: {date}'**
  String salesBusinessDate(Object date);

  /// No description provided for @salesPriceLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get salesPriceLarge;

  /// No description provided for @salesPriceSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get salesPriceSmall;

  /// No description provided for @salesPriceRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get salesPriceRice;

  /// No description provided for @salesCashDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Details'**
  String get salesCashDetailsTitle;

  /// No description provided for @salesCashDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your starting cash, ticket deduction, and actual counted cash.'**
  String get salesCashDetailsSubtitle;

  /// No description provided for @salesStartingCash.
  ///
  /// In en, this message translates to:
  /// **'Starting Cash'**
  String get salesStartingCash;

  /// No description provided for @salesTicketDeductionToday.
  ///
  /// In en, this message translates to:
  /// **'Ticket Deduction Today'**
  String get salesTicketDeductionToday;

  /// No description provided for @salesTicketDeductionHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 if no ticket today. Example: 30, 60, etc.'**
  String get salesTicketDeductionHelper;

  /// No description provided for @salesActualCashCounted.
  ///
  /// In en, this message translates to:
  /// **'Actual Cash Counted'**
  String get salesActualCashCounted;

  /// No description provided for @salesProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get salesProductsTitle;

  /// No description provided for @salesProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter daily stock movement for each item.'**
  String get salesProductsSubtitle;

  /// No description provided for @salesProductChickenLarge.
  ///
  /// In en, this message translates to:
  /// **'Chicken Large'**
  String get salesProductChickenLarge;

  /// No description provided for @salesProductChickenSmall.
  ///
  /// In en, this message translates to:
  /// **'Chicken Small'**
  String get salesProductChickenSmall;

  /// No description provided for @salesProductLumpia.
  ///
  /// In en, this message translates to:
  /// **'Lumpia'**
  String get salesProductLumpia;

  /// No description provided for @salesProductRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get salesProductRice;

  /// No description provided for @salesPriceEach.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String salesPriceEach(Object price);

  /// No description provided for @salesBeginning.
  ///
  /// In en, this message translates to:
  /// **'Beginning'**
  String get salesBeginning;

  /// No description provided for @salesDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get salesDelivered;

  /// No description provided for @salesRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get salesRemaining;

  /// No description provided for @salesSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get salesSold;

  /// No description provided for @salesSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesSales;

  /// No description provided for @salesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get salesSummaryTitle;

  /// No description provided for @salesGrossSales.
  ///
  /// In en, this message translates to:
  /// **'Gross Sales'**
  String get salesGrossSales;

  /// No description provided for @salesTicketDeduction.
  ///
  /// In en, this message translates to:
  /// **'Ticket Deduction'**
  String get salesTicketDeduction;

  /// No description provided for @salesNetSales.
  ///
  /// In en, this message translates to:
  /// **'Net Sales'**
  String get salesNetSales;

  /// No description provided for @salesExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get salesExpectedCash;

  /// No description provided for @salesActualCash.
  ///
  /// In en, this message translates to:
  /// **'Actual Cash'**
  String get salesActualCash;

  /// No description provided for @salesNoInputYet.
  ///
  /// In en, this message translates to:
  /// **'No input yet'**
  String get salesNoInputYet;

  /// No description provided for @salesDifferenceWithStatus.
  ///
  /// In en, this message translates to:
  /// **'Difference ({status})'**
  String salesDifferenceWithStatus(Object status);

  /// No description provided for @salesDifferenceNoInput.
  ///
  /// In en, this message translates to:
  /// **'No input'**
  String get salesDifferenceNoInput;

  /// No description provided for @salesDifferenceNoInputStatus.
  ///
  /// In en, this message translates to:
  /// **'No Input'**
  String get salesDifferenceNoInputStatus;

  /// No description provided for @salesDifferenceShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get salesDifferenceShort;

  /// No description provided for @salesDifferenceOver.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get salesDifferenceOver;

  /// No description provided for @salesDifferenceMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get salesDifferenceMatch;

  /// No description provided for @salesValidationChickenLarge.
  ///
  /// In en, this message translates to:
  /// **'Chicken Large is invalid. Remaining stock cannot be greater than beginning + delivered.'**
  String get salesValidationChickenLarge;

  /// No description provided for @salesValidationChickenSmall.
  ///
  /// In en, this message translates to:
  /// **'Chicken Small is invalid. Remaining stock cannot be greater than beginning + delivered.'**
  String get salesValidationChickenSmall;

  /// No description provided for @salesValidationLumpia.
  ///
  /// In en, this message translates to:
  /// **'Lumpia is invalid. Remaining stock cannot be greater than beginning + delivered.'**
  String get salesValidationLumpia;

  /// No description provided for @salesValidationRice.
  ///
  /// In en, this message translates to:
  /// **'Rice is invalid. Remaining rice cannot be greater than delivered rice.'**
  String get salesValidationRice;

  /// No description provided for @salesResetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all inputs?'**
  String get salesResetDialogTitle;

  /// No description provided for @salesResetDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear all fields on the page. Your saved history will stay unless you overwrite it by saving again.'**
  String get salesResetDialogMessage;

  /// No description provided for @salesResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Result'**
  String get salesResultTitle;

  /// No description provided for @salesSaveEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least some data before saving.'**
  String get salesSaveEmptyError;

  /// No description provided for @salesUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Today\'s record updated successfully.'**
  String get salesUpdatedSuccess;

  /// No description provided for @salesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Today\'s record saved successfully.'**
  String get salesSavedSuccess;

  /// No description provided for @salesResetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get salesResetAction;

  /// No description provided for @salesCalculateAction.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get salesCalculateAction;

  /// No description provided for @salesUpdateToday.
  ///
  /// In en, this message translates to:
  /// **'Update Today'**
  String get salesUpdateToday;

  /// No description provided for @salesSaveToday.
  ///
  /// In en, this message translates to:
  /// **'Save Today'**
  String get salesSaveToday;
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
      <String>['en', 'fil'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
