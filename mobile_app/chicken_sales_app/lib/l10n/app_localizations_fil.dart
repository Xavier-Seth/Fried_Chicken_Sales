// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Calculator ng Benta ng Manok';

  @override
  String get navSales => 'Benta';

  @override
  String get navHistory => 'Kasaysayan';

  @override
  String get navCharts => 'Tsart';

  @override
  String get navSettings => 'Settings';

  @override
  String get salesAppBarTitle => 'Arawang Benta';

  @override
  String get historyAppBarTitle => 'Kasaysayan ng Benta';

  @override
  String get historyOverviewTitle => 'Buod ng Benta';

  @override
  String historyDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count araw',
      one: '1 araw',
      zero: '0 araw',
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
  String get historyRowExpected => 'Inaasahan';

  @override
  String get historyRowActual => 'Aktuwal';

  @override
  String get historyStatusShort => 'Kulang';

  @override
  String get historyStatusOver => 'Sobra';

  @override
  String get historyStatusMatch => 'Tugma';

  @override
  String get historyDeleteRecordTitle => 'Burahin ang record?';

  @override
  String historyDeleteRecordMessage(Object date) {
    return 'Burahin ang naka-save na record para sa $date?';
  }

  @override
  String get historyDeleteAllTitle => 'Burahin ang lahat ng history?';

  @override
  String get historyDeleteAllMessage =>
      'Permanenteng mabubura ang lahat ng naka-save na record.';

  @override
  String get historyDeleteAllConfirm => 'Burahin Lahat';

  @override
  String get historyEmptyTitle => 'Wala pang records';

  @override
  String get chartsAppBarTitle => 'Mga Tsart ng Benta';

  @override
  String get chartsHeroTitle => 'Buod ng Tsart ng Benta';

  @override
  String get chartsHeroSubtitle =>
      'Net sales para sa mga pinakahuling naka-save na araw.';

  @override
  String chartsDaysSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count araw',
      one: '1 araw',
      zero: '0 araw',
    );
    return '$_temp0';
  }

  @override
  String get chartsHighestNet => 'Pinakamataas na Net';

  @override
  String get chartsTotalNet => 'Kabuuang Net';

  @override
  String get chartsGross => 'Gross';

  @override
  String get chartsSaved => 'Naka-save';

  @override
  String get chartsEmptyTitle => 'Wala pang data ng tsart';

  @override
  String get chartsEmptySubtitle =>
      'Mag-save ng arawang benta mula sa Sales tab para makagawa ng chart data.';

  @override
  String get chartsRefresh => 'I-refresh';

  @override
  String get chartsNetSalesChartTitle => 'Tsart ng Net Sales';

  @override
  String chartsLastSavedDays(int count) {
    return 'Huling $count naka-save na araw';
  }

  @override
  String get settingsAppBarTitle => 'Settings';

  @override
  String get settingsHeroTitle => 'POS Settings';

  @override
  String get settingsHeroSubtitle =>
      'I-update dito ang wika at presyo ng mga produkto.';

  @override
  String get settingsLanguageSectionTitle => 'Wika';

  @override
  String get settingsLanguageSectionSubtitle =>
      'Piliin ang wikang gagamitin ng app interface.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFilipino => 'Filipino';

  @override
  String get settingsLanguageEnglishSubtitle =>
      'Gamitin ang English sa buong app.';

  @override
  String get settingsLanguageFilipinoSubtitle =>
      'Gamitin ang Filipino sa buong app.';

  @override
  String get settingsLanguageSaved => 'Matagumpay na na-update ang wika.';

  @override
  String get settingsProductPricesTitle => 'Presyo ng mga Produkto';

  @override
  String get settingsProductPricesSubtitle =>
      'Gagamitin ang mga value na ito sa Sales, History, at Charts.';

  @override
  String get settingsChickenLargePrice => 'Presyo ng Chicken Large';

  @override
  String get settingsChickenSmallPrice => 'Presyo ng Chicken Small';

  @override
  String get settingsLumpiaPrice => 'Presyo ng Lumpia';

  @override
  String get settingsRicePrice => 'Presyo ng Rice';

  @override
  String settingsDefaultPrice(Object value) {
    return 'Default: $value';
  }

  @override
  String get settingsResetDefaults => 'I-reset ang Default';

  @override
  String get settingsSaveSettings => 'I-save ang Settings';

  @override
  String get settingsSavedSuccessfully => 'Matagumpay na na-save ang settings.';

  @override
  String get settingsResetSuccessfully =>
      'Na-reset na sa default ang settings.';

  @override
  String get commonCancel => 'Kanselahin';

  @override
  String get commonDelete => 'Burahin';

  @override
  String get commonOk => 'OK';

  @override
  String get salesHeroTitle => 'POS ng Benta ng Manok';

  @override
  String salesBusinessDate(Object date) {
    return 'Petsa ng Negosyo: $date';
  }

  @override
  String get salesPriceLarge => 'Large';

  @override
  String get salesPriceSmall => 'Small';

  @override
  String get salesPriceRice => 'Rice';

  @override
  String get salesCashDetailsTitle => 'Detalye ng Pera';

  @override
  String get salesCashDetailsSubtitle =>
      'Ilagay ang panimulang pera, kaltas sa ticket, at aktuwal na nabilang na pera.';

  @override
  String get salesStartingCash => 'Panimulang Pera';

  @override
  String get salesTicketDeductionToday => 'Kaltas sa Ticket Ngayon';

  @override
  String get salesTicketDeductionHelper =>
      'Ilagay ang 0 kung walang ticket ngayon. Halimbawa: 30, 60, atbp.';

  @override
  String get salesActualCashCounted => 'Aktuwal na Nabilang na Pera';

  @override
  String get salesProductsTitle => 'Mga Produkto';

  @override
  String get salesProductsSubtitle =>
      'Ilagay ang galaw ng stock ng bawat item sa araw na ito.';

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
    return '$price bawat isa';
  }

  @override
  String get salesBeginning => 'Simula';

  @override
  String get salesDelivered => 'Naideliver';

  @override
  String get salesRemaining => 'Natira';

  @override
  String get salesSold => 'Nabenta';

  @override
  String get salesSales => 'Benta';

  @override
  String get salesSummaryTitle => 'Buod';

  @override
  String get salesGrossSales => 'Gross Sales';

  @override
  String get salesTicketDeduction => 'Kaltas sa Ticket';

  @override
  String get salesNetSales => 'Net Sales';

  @override
  String get salesExpectedCash => 'Inaasahang Pera';

  @override
  String get salesActualCash => 'Aktuwal na Pera';

  @override
  String get salesNoInputYet => 'Wala pang input';

  @override
  String salesDifferenceWithStatus(Object status) {
    return 'Pagkakaiba ($status)';
  }

  @override
  String get salesDifferenceNoInput => 'Walang input';

  @override
  String get salesDifferenceNoInputStatus => 'Walang Input';

  @override
  String get salesDifferenceShort => 'Kulang';

  @override
  String get salesDifferenceOver => 'Sobra';

  @override
  String get salesDifferenceMatch => 'Tugma';

  @override
  String get salesValidationChickenLarge =>
      'Hindi wasto ang Chicken Large. Hindi puwedeng mas mataas ang natitirang stock kaysa sa simula + naideliver.';

  @override
  String get salesValidationChickenSmall =>
      'Hindi wasto ang Chicken Small. Hindi puwedeng mas mataas ang natitirang stock kaysa sa simula + naideliver.';

  @override
  String get salesValidationLumpia =>
      'Hindi wasto ang Lumpia. Hindi puwedeng mas mataas ang natitirang stock kaysa sa simula + naideliver.';

  @override
  String get salesValidationRice =>
      'Hindi wasto ang Rice. Hindi puwedeng mas mataas ang natitirang rice kaysa sa naideliver na rice.';

  @override
  String get salesResetDialogTitle => 'I-reset ang lahat ng input?';

  @override
  String get salesResetDialogMessage =>
      'Lilinisin nito ang lahat ng field sa page. Mananatili ang naka-save mong history maliban kung ma-overwrite ito kapag nag-save ka ulit.';

  @override
  String get salesResultTitle => 'Resulta ng Benta';

  @override
  String get salesSaveEmptyError =>
      'Maglagay muna ng kahit kaunting data bago mag-save.';

  @override
  String get salesUpdatedSuccess =>
      'Matagumpay na na-update ang record ngayong araw.';

  @override
  String get salesSavedSuccess =>
      'Matagumpay na na-save ang record ngayong araw.';

  @override
  String get salesResetAction => 'I-reset';

  @override
  String get salesCalculateAction => 'Kalkulahin';

  @override
  String get salesUpdateToday => 'I-update Ngayon';

  @override
  String get salesSaveToday => 'I-save Ngayon';
}
