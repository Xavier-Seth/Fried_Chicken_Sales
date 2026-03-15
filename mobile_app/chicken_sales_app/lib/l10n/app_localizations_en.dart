// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chicken Sales Calculator';

  @override
  String get navSales => 'Sales';

  @override
  String get navHistory => 'History';

  @override
  String get navCharts => 'Charts';

  @override
  String get navSettings => 'Settings';

  @override
  String get salesAppBarTitle => 'Daily Sales';

  @override
  String get historyAppBarTitle => 'Sales History';

  @override
  String get historyOverviewTitle => 'Sales Overview';

  @override
  String historyDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: '0 days',
    );
    return '$_temp0';
  }

  @override
  String get historySummaryNet => 'Net';

  @override
  String get historySummaryGross => 'Gross';

  @override
  String get historySummaryTicket => 'Ticket';

  @override
  String get historyRowGross => 'Gross';

  @override
  String get historyRowTicket => 'Ticket';

  @override
  String get historyRowNet => 'Net';

  @override
  String get historyRowExpected => 'Expected';

  @override
  String get historyRowActual => 'Actual';

  @override
  String get historyStatusShort => 'Short';

  @override
  String get historyStatusOver => 'Over';

  @override
  String get historyStatusMatch => 'Match';

  @override
  String get historyDeleteRecordTitle => 'Delete record?';

  @override
  String historyDeleteRecordMessage(Object date) {
    return 'Delete saved record for $date?';
  }

  @override
  String get historyDeleteAllTitle => 'Delete all history?';

  @override
  String get historyDeleteAllMessage =>
      'This will remove all saved records permanently.';

  @override
  String get historyDeleteAllConfirm => 'Delete All';

  @override
  String get historyEmptyTitle => 'No records yet';

  @override
  String get chartsAppBarTitle => 'Sales Charts';

  @override
  String get chartsHeroTitle => 'Sales Chart Overview';

  @override
  String get chartsHeroSubtitle => 'Net sales for the latest saved days.';

  @override
  String chartsDaysSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: '0 days',
    );
    return '$_temp0';
  }

  @override
  String get chartsHighestNet => 'Highest Net';

  @override
  String get chartsTotalNet => 'Total Net';

  @override
  String get chartsGross => 'Gross';

  @override
  String get chartsSaved => 'Saved';

  @override
  String get chartsEmptyTitle => 'No chart data yet';

  @override
  String get chartsEmptySubtitle =>
      'Save daily sales from the Sales tab to generate chart data.';

  @override
  String get chartsRefresh => 'Refresh';

  @override
  String get chartsNetSalesChartTitle => 'Net Sales Chart';

  @override
  String chartsLastSavedDays(int count) {
    return 'Last $count saved day(s)';
  }

  @override
  String get settingsAppBarTitle => 'Settings';

  @override
  String get settingsHeroTitle => 'POS Settings';

  @override
  String get settingsHeroSubtitle => 'Update language and product prices here.';

  @override
  String get settingsLanguageSectionTitle => 'Language';

  @override
  String get settingsLanguageSectionSubtitle =>
      'Choose the language used by the app interface.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFilipino => 'Filipino';

  @override
  String get settingsLanguageEnglishSubtitle => 'Use English across the app.';

  @override
  String get settingsLanguageFilipinoSubtitle => 'Use Filipino across the app.';

  @override
  String get settingsLanguageSaved => 'Language updated successfully.';

  @override
  String get settingsProductPricesTitle => 'Product Prices';

  @override
  String get settingsProductPricesSubtitle =>
      'These values will be used in Sales, History, and Charts.';

  @override
  String get settingsChickenLargePrice => 'Chicken Large Price';

  @override
  String get settingsChickenSmallPrice => 'Chicken Small Price';

  @override
  String get settingsLumpiaPrice => 'Lumpia Price';

  @override
  String get settingsRicePrice => 'Rice Price';

  @override
  String settingsDefaultPrice(Object value) {
    return 'Default: $value';
  }

  @override
  String get settingsResetDefaults => 'Reset Defaults';

  @override
  String get settingsSaveSettings => 'Save Settings';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully.';

  @override
  String get settingsResetSuccessfully => 'Settings reset to default values.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonOk => 'OK';

  @override
  String get salesHeroTitle => 'Chicken Sales POS';

  @override
  String salesBusinessDate(Object date) {
    return 'Business Date: $date';
  }

  @override
  String get salesPriceLarge => 'Large';

  @override
  String get salesPriceSmall => 'Small';

  @override
  String get salesPriceRice => 'Rice';

  @override
  String get salesCashDetailsTitle => 'Cash Details';

  @override
  String get salesCashDetailsSubtitle =>
      'Enter your starting cash, ticket deduction, and actual counted cash.';

  @override
  String get salesStartingCash => 'Starting Cash';

  @override
  String get salesTicketDeductionToday => 'Ticket Deduction Today';

  @override
  String get salesTicketDeductionHelper =>
      'Enter 0 if no ticket today. Example: 30, 60, etc.';

  @override
  String get salesActualCashCounted => 'Actual Cash Counted';

  @override
  String get salesProductsTitle => 'Products';

  @override
  String get salesProductsSubtitle =>
      'Enter daily stock movement for each item.';

  @override
  String get salesProductChickenLarge => 'Chicken Large';

  @override
  String get salesProductChickenSmall => 'Chicken Small';

  @override
  String get salesProductLumpia => 'Lumpia';

  @override
  String get salesProductRice => 'Rice';

  @override
  String salesPriceEach(Object price) {
    return '$price each';
  }

  @override
  String get salesBeginning => 'Beginning';

  @override
  String get salesDelivered => 'Delivered';

  @override
  String get salesRemaining => 'Remaining';

  @override
  String get salesSold => 'Sold';

  @override
  String get salesSales => 'Sales';

  @override
  String get salesSummaryTitle => 'Summary';

  @override
  String get salesGrossSales => 'Gross Sales';

  @override
  String get salesTicketDeduction => 'Ticket Deduction';

  @override
  String get salesNetSales => 'Net Sales';

  @override
  String get salesExpectedCash => 'Expected Cash';

  @override
  String get salesActualCash => 'Actual Cash';

  @override
  String get salesNoInputYet => 'No input yet';

  @override
  String salesDifferenceWithStatus(Object status) {
    return 'Difference ($status)';
  }

  @override
  String get salesDifferenceNoInput => 'No input';

  @override
  String get salesDifferenceNoInputStatus => 'No Input';

  @override
  String get salesDifferenceShort => 'Short';

  @override
  String get salesDifferenceOver => 'Over';

  @override
  String get salesDifferenceMatch => 'Match';

  @override
  String get salesValidationChickenLarge =>
      'Chicken Large is invalid. Remaining stock cannot be greater than beginning + delivered.';

  @override
  String get salesValidationChickenSmall =>
      'Chicken Small is invalid. Remaining stock cannot be greater than beginning + delivered.';

  @override
  String get salesValidationLumpia =>
      'Lumpia is invalid. Remaining stock cannot be greater than beginning + delivered.';

  @override
  String get salesValidationRice =>
      'Rice is invalid. Remaining rice cannot be greater than delivered rice.';

  @override
  String get salesResetDialogTitle => 'Reset all inputs?';

  @override
  String get salesResetDialogMessage =>
      'This will clear all fields on the page. Your saved history will stay unless you overwrite it by saving again.';

  @override
  String get salesResultTitle => 'Sales Result';

  @override
  String get salesSaveEmptyError =>
      'Please enter at least some data before saving.';

  @override
  String get salesUpdatedSuccess => 'Today\'s record updated successfully.';

  @override
  String get salesSavedSuccess => 'Today\'s record saved successfully.';

  @override
  String get salesResetAction => 'Reset';

  @override
  String get salesCalculateAction => 'Calculate';

  @override
  String get salesUpdateToday => 'Update Today';

  @override
  String get salesSaveToday => 'Save Today';
}
