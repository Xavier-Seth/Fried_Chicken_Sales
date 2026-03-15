import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../logic/sales_calculator.dart';
import '../models/sales_record.dart';
import '../services/sales_refresh_notifier.dart';
import '../services/sales_storage.dart';
import '../services/settings_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with AutomaticKeepAliveClientMixin {
  final pesoFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 0,
  );

  final startingCash = TextEditingController();
  final actualCashCounted = TextEditingController();
  final ticketDeductionController = TextEditingController();

  final chickenLargeBeginning = TextEditingController();
  final chickenLargeDelivered = TextEditingController();
  final chickenLargeRemaining = TextEditingController();

  final chickenSmallBeginning = TextEditingController();
  final chickenSmallDelivered = TextEditingController();
  final chickenSmallRemaining = TextEditingController();

  final lumpiaBeginning = TextEditingController();
  final lumpiaDelivered = TextEditingController();
  final lumpiaRemaining = TextEditingController();

  final riceDelivered = TextEditingController();
  final riceRemaining = TextEditingController();

  int chickenLargePrice = SettingsService.defaultChickenLargePrice;
  int chickenSmallPrice = SettingsService.defaultChickenSmallPrice;
  int lumpiaPrice = SettingsService.defaultLumpiaPrice;
  int ricePrice = SettingsService.defaultRicePrice;

  int soldChickenLarge = 0;
  int soldChickenSmall = 0;
  int soldLumpia = 0;
  int soldRice = 0;

  int grossSales = 0;
  int netSales = 0;
  int expectedCash = 0;
  int cashDifference = 0;

  bool hasSavedToday = false;
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    SalesRefreshNotifier.refreshKey.addListener(_handleRefresh);
    loadInitialData();
  }

  void _handleRefresh() {
    loadInitialData();
  }

  String get todayBusinessDate =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool get hasActualCashInput => actualCashCounted.text.trim().isNotEmpty;

  int parseValue(TextEditingController controller) {
    return int.tryParse(controller.text.trim()) ?? 0;
  }

  bool hasNegativeValue(TextEditingController controller) {
    return controller.text.trim().startsWith('-');
  }

  bool get invalidChickenLarge {
    final b = parseValue(chickenLargeBeginning);
    final d = parseValue(chickenLargeDelivered);
    final r = parseValue(chickenLargeRemaining);

    return r > (b + d) ||
        hasNegativeValue(chickenLargeBeginning) ||
        hasNegativeValue(chickenLargeDelivered) ||
        hasNegativeValue(chickenLargeRemaining);
  }

  bool get invalidChickenSmall {
    final b = parseValue(chickenSmallBeginning);
    final d = parseValue(chickenSmallDelivered);
    final r = parseValue(chickenSmallRemaining);

    return r > (b + d) ||
        hasNegativeValue(chickenSmallBeginning) ||
        hasNegativeValue(chickenSmallDelivered) ||
        hasNegativeValue(chickenSmallRemaining);
  }

  bool get invalidLumpia {
    final b = parseValue(lumpiaBeginning);
    final d = parseValue(lumpiaDelivered);
    final r = parseValue(lumpiaRemaining);

    return r > (b + d) ||
        hasNegativeValue(lumpiaBeginning) ||
        hasNegativeValue(lumpiaDelivered) ||
        hasNegativeValue(lumpiaRemaining);
  }

  bool get invalidRice {
    final d = parseValue(riceDelivered);
    final r = parseValue(riceRemaining);

    return r > d ||
        hasNegativeValue(riceDelivered) ||
        hasNegativeValue(riceRemaining);
  }

  bool get hasInvalidStock {
    return invalidChickenLarge ||
        invalidChickenSmall ||
        invalidLumpia ||
        invalidRice;
  }

  String getValidationMessage() {
    final l10n = AppLocalizations.of(context);

    if (invalidChickenLarge) {
      return l10n.salesValidationChickenLarge;
    }
    if (invalidChickenSmall) {
      return l10n.salesValidationChickenSmall;
    }
    if (invalidLumpia) {
      return l10n.salesValidationLumpia;
    }
    if (invalidRice) {
      return l10n.salesValidationRice;
    }
    return '';
  }

  bool get isCompletelyEmpty {
    return startingCash.text.trim().isEmpty &&
        actualCashCounted.text.trim().isEmpty &&
        ticketDeductionController.text.trim().isEmpty &&
        chickenLargeBeginning.text.trim().isEmpty &&
        chickenLargeDelivered.text.trim().isEmpty &&
        chickenLargeRemaining.text.trim().isEmpty &&
        chickenSmallBeginning.text.trim().isEmpty &&
        chickenSmallDelivered.text.trim().isEmpty &&
        chickenSmallRemaining.text.trim().isEmpty &&
        lumpiaBeginning.text.trim().isEmpty &&
        lumpiaDelivered.text.trim().isEmpty &&
        lumpiaRemaining.text.trim().isEmpty &&
        riceDelivered.text.trim().isEmpty &&
        riceRemaining.text.trim().isEmpty;
  }

  Future<void> loadInitialData() async {
    final settings = await SettingsService.getSettings();
    final record = await SalesStorage.getRecordByBusinessDate(
      todayBusinessDate,
    );

    if (!mounted) return;

    chickenLargePrice = settings.chickenLargePrice;
    chickenSmallPrice = settings.chickenSmallPrice;
    lumpiaPrice = settings.lumpiaPrice;
    ricePrice = settings.ricePrice;

    if (record != null) {
      startingCash.text = record.startingCashInput;
      actualCashCounted.text = record.actualCashCountedInput;
      ticketDeductionController.text = record.ticketDeduction.toString();

      chickenLargeBeginning.text = record.chickenLargeBeginningInput;
      chickenLargeDelivered.text = record.chickenLargeDeliveredInput;
      chickenLargeRemaining.text = record.chickenLargeRemainingInput;

      chickenSmallBeginning.text = record.chickenSmallBeginningInput;
      chickenSmallDelivered.text = record.chickenSmallDeliveredInput;
      chickenSmallRemaining.text = record.chickenSmallRemainingInput;

      lumpiaBeginning.text = record.lumpiaBeginningInput;
      lumpiaDelivered.text = record.lumpiaDeliveredInput;
      lumpiaRemaining.text = record.lumpiaRemainingInput;

      riceDelivered.text = record.riceDeliveredInput;
      riceRemaining.text = record.riceRemainingInput;
    } else {
      ticketDeductionController.text = '0';
    }

    setState(() {
      hasSavedToday = record != null;
      isLoading = false;
    });

    calculateSales();
  }

  void calculateSales({bool showModal = false}) {
    final result = SalesCalculator.calculate(
      startingCash: parseValue(startingCash),
      actualCash: parseValue(actualCashCounted),
      hasActualCashInput: hasActualCashInput,
      chickenLargeBeginning: parseValue(chickenLargeBeginning),
      chickenLargeDelivered: parseValue(chickenLargeDelivered),
      chickenLargeRemaining: parseValue(chickenLargeRemaining),
      chickenSmallBeginning: parseValue(chickenSmallBeginning),
      chickenSmallDelivered: parseValue(chickenSmallDelivered),
      chickenSmallRemaining: parseValue(chickenSmallRemaining),
      lumpiaBeginning: parseValue(lumpiaBeginning),
      lumpiaDelivered: parseValue(lumpiaDelivered),
      lumpiaRemaining: parseValue(lumpiaRemaining),
      riceDelivered: parseValue(riceDelivered),
      riceRemaining: parseValue(riceRemaining),
      chickenLargePrice: chickenLargePrice,
      chickenSmallPrice: chickenSmallPrice,
      lumpiaPrice: lumpiaPrice,
      ricePrice: ricePrice,
      ticketDeduction: parseValue(ticketDeductionController),
    );

    setState(() {
      soldChickenLarge = result.soldChickenLarge;
      soldChickenSmall = result.soldChickenSmall;
      soldLumpia = result.soldLumpia;
      soldRice = result.soldRice;
      grossSales = result.grossSales;
      netSales = result.netSales;
      expectedCash = result.expectedCash;
      cashDifference = result.cashDifference;
    });

    if (showModal) {
      showSalesResultModal();
    }
  }

  SalesRecord buildTodayRecord() {
    final now = DateTime.now();

    return SalesRecord(
      id: todayBusinessDate,
      businessDate: todayBusinessDate,
      date: DateFormat('yyyy-MM-dd – hh:mm a').format(now),
      grossSales: grossSales,
      netSales: netSales,
      totalSales: netSales,
      ticketDeduction: parseValue(ticketDeductionController),
      expectedCash: expectedCash,
      actualCash: parseValue(actualCashCounted),
      difference: cashDifference,
      chickenLargePrice: chickenLargePrice,
      chickenSmallPrice: chickenSmallPrice,
      lumpiaPrice: lumpiaPrice,
      ricePrice: ricePrice,
      soldChickenLarge: soldChickenLarge,
      soldChickenSmall: soldChickenSmall,
      soldLumpia: soldLumpia,
      soldRice: soldRice,
      startingCashInput: startingCash.text.trim(),
      actualCashCountedInput: actualCashCounted.text.trim(),
      chickenLargeBeginningInput: chickenLargeBeginning.text.trim(),
      chickenLargeDeliveredInput: chickenLargeDelivered.text.trim(),
      chickenLargeRemainingInput: chickenLargeRemaining.text.trim(),
      chickenSmallBeginningInput: chickenSmallBeginning.text.trim(),
      chickenSmallDeliveredInput: chickenSmallDelivered.text.trim(),
      chickenSmallRemainingInput: chickenSmallRemaining.text.trim(),
      lumpiaBeginningInput: lumpiaBeginning.text.trim(),
      lumpiaDeliveredInput: lumpiaDelivered.text.trim(),
      lumpiaRemainingInput: lumpiaRemaining.text.trim(),
      riceDeliveredInput: riceDelivered.text.trim(),
      riceRemainingInput: riceRemaining.text.trim(),
    );
  }

  void resetInputs() {
    startingCash.clear();
    actualCashCounted.clear();
    ticketDeductionController.text = '0';

    chickenLargeBeginning.clear();
    chickenLargeDelivered.clear();
    chickenLargeRemaining.clear();

    chickenSmallBeginning.clear();
    chickenSmallDelivered.clear();
    chickenSmallRemaining.clear();

    lumpiaBeginning.clear();
    lumpiaDelivered.clear();
    lumpiaRemaining.clear();

    riceDelivered.clear();
    riceRemaining.clear();

    setState(() {
      soldChickenLarge = 0;
      soldChickenSmall = 0;
      soldLumpia = 0;
      soldRice = 0;
      grossSales = 0;
      netSales = 0;
      expectedCash = 0;
      cashDifference = 0;
      hasSavedToday = false;
    });
  }

  Future<void> confirmReset() async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.salesResetDialogTitle),
          content: Text(l10n.salesResetDialogMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: Text(l10n.salesResetAction),
            ),
          ],
        );
      },
    );

    if (result == true) {
      resetInputs();
    }
  }

  Future<void> showSalesResultModal() async {
    final l10n = AppLocalizations.of(context);
    final countedCashValue = parseValue(actualCashCounted);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            l10n.salesResultTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              modalRow(l10n.salesGrossSales, pesoFormat.format(grossSales)),
              const SizedBox(height: 10),
              modalRow(
                l10n.salesTicketDeduction,
                pesoFormat.format(parseValue(ticketDeductionController)),
              ),
              const SizedBox(height: 10),
              modalRow(l10n.salesNetSales, pesoFormat.format(netSales)),
              const SizedBox(height: 10),
              modalRow(l10n.salesExpectedCash, pesoFormat.format(expectedCash)),
              const SizedBox(height: 10),
              modalRow(
                l10n.salesActualCash,
                pesoFormat.format(countedCashValue),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: differenceColor().withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: differenceColor().withAlpha(60)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.salesDifferenceWithStatus(differenceLabel()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: differenceColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      pesoFormat.format(cashDifference),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: differenceColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: Text(l10n.commonOk),
            ),
          ],
        );
      },
    );
  }

  Color differenceColor() {
    if (!hasActualCashInput) return const Color(0xFF0F172A);
    if (cashDifference < 0) return Colors.red;
    if (cashDifference > 0) return Colors.green;
    return const Color(0xFF0F172A);
  }

  String differenceLabel() {
    final l10n = AppLocalizations.of(context);

    if (!hasActualCashInput) return l10n.salesDifferenceNoInputStatus;
    if (cashDifference < 0) return l10n.salesDifferenceShort;
    if (cashDifference > 0) return l10n.salesDifferenceOver;
    return l10n.salesDifferenceMatch;
  }

  Future<void> saveCurrentRecord() async {
    final l10n = AppLocalizations.of(context);

    calculateSales();

    if (hasInvalidStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getValidationMessage()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isCompletelyEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.salesSaveEmptyError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final wasAlreadySaved = hasSavedToday;
    final record = buildTodayRecord();
    await SalesStorage.saveOrUpdateRecord(record);

    if (!mounted) return;

    setState(() {
      hasSavedToday = true;
    });

    SalesRefreshNotifier.notifyRefresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadySaved ? l10n.salesUpdatedSuccess : l10n.salesSavedSuccess,
        ),
        backgroundColor: const Color(0xFFF59E0B),
      ),
    );
  }

  InputDecoration modernInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE6E8EF), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 1.8),
      ),
      labelStyle: const TextStyle(color: Color(0xFF7A8194), fontSize: 13),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFFF59E0B),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget inputField(
    String label,
    TextEditingController controller, {
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (helperText != null && helperText.trim().isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              helperText,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => calculateSales(),
          decoration: modernInputDecoration(label),
        ),
      ],
    );
  }

  Widget modalRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5C6475)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202431),
          ),
        ),
      ],
    );
  }

  Widget heroCard() {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30F59E0B),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.salesHeroTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.salesBusinessDate(todayBusinessDate),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              topBadge(
                l10n.salesPriceLarge,
                pesoFormat.format(chickenLargePrice),
              ),
              const SizedBox(width: 8),
              topBadge(
                l10n.salesPriceSmall,
                pesoFormat.format(chickenSmallPrice),
              ),
              const SizedBox(width: 8),
              topBadge(l10n.salesPriceRice, pesoFormat.format(ricePrice)),
            ],
          ),
        ],
      ),
    );
  }

  Widget topBadge(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(28)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget productCard({
    required String title,
    required String priceLabel,
    required TextEditingController beginningController,
    required TextEditingController deliveredController,
    required TextEditingController remainingController,
    required int soldQty,
    required int lineSales,
  }) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_rounded, color: Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    priceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFEA580C),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: inputField(l10n.salesBeginning, beginningController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: inputField(l10n.salesDelivered, deliveredController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: inputField(l10n.salesRemaining, remainingController),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              summaryPill(l10n.salesSold, '$soldQty'),
              const SizedBox(width: 10),
              summaryPill(l10n.salesSales, pesoFormat.format(lineSales)),
            ],
          ),
        ],
      ),
    );
  }

  Widget riceCard() {
    final l10n = AppLocalizations.of(context);
    final riceSales = soldRice * ricePrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rice_bowl_rounded, color: Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.salesProductRice,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.salesPriceEach(pesoFormat.format(ricePrice)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFEA580C),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: inputField(l10n.salesDelivered, riceDelivered)),
              const SizedBox(width: 10),
              Expanded(child: inputField(l10n.salesRemaining, riceRemaining)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              summaryPill(l10n.salesSold, '$soldRice'),
              const SizedBox(width: 10),
              summaryPill(l10n.salesSales, pesoFormat.format(riceSales)),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryPill(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalsCard() {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.salesSummaryTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          summaryRow(l10n.salesGrossSales, pesoFormat.format(grossSales)),
          const SizedBox(height: 10),
          summaryRow(
            l10n.salesTicketDeduction,
            pesoFormat.format(parseValue(ticketDeductionController)),
          ),
          const SizedBox(height: 10),
          summaryRow(l10n.salesNetSales, pesoFormat.format(netSales)),
          const SizedBox(height: 10),
          summaryRow(l10n.salesExpectedCash, pesoFormat.format(expectedCash)),
          const SizedBox(height: 10),
          summaryRow(
            l10n.salesActualCash,
            hasActualCashInput
                ? pesoFormat.format(parseValue(actualCashCounted))
                : l10n.salesNoInputYet,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: differenceColor().withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: differenceColor().withAlpha(60)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.salesDifferenceWithStatus(differenceLabel()),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: differenceColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  hasActualCashInput
                      ? pesoFormat.format(cashDifference)
                      : l10n.salesDifferenceNoInput,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: differenceColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget validationCard() {
    if (!hasInvalidStock) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              getValidationMessage(),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButtons() {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: confirmReset,
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(
                  l10n.salesResetAction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: Color(0xFFF59E0B)),
                  foregroundColor: const Color(0xFFF59E0B),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => calculateSales(showModal: true),
                icon: const Icon(Icons.calculate_rounded, size: 18),
                label: Text(
                  l10n.salesCalculateAction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: saveCurrentRecord,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(
                  hasSavedToday ? l10n.salesUpdateToday : l10n.salesSaveToday,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SalesRefreshNotifier.refreshKey.removeListener(_handleRefresh);

    startingCash.dispose();
    actualCashCounted.dispose();
    ticketDeductionController.dispose();

    chickenLargeBeginning.dispose();
    chickenLargeDelivered.dispose();
    chickenLargeRemaining.dispose();

    chickenSmallBeginning.dispose();
    chickenSmallDelivered.dispose();
    chickenSmallRemaining.dispose();

    lumpiaBeginning.dispose();
    lumpiaDelivered.dispose();
    lumpiaRemaining.dispose();

    riceDelivered.dispose();
    riceRemaining.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = AppLocalizations.of(context);
    final chickenLargeLineSales = soldChickenLarge * chickenLargePrice;
    final chickenSmallLineSales = soldChickenSmall * chickenSmallPrice;
    final lumpiaLineSales = soldLumpia * lumpiaPrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          l10n.salesAppBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                heroCard(),
                sectionCard(
                  title: l10n.salesCashDetailsTitle,
                  subtitle: l10n.salesCashDetailsSubtitle,
                  child: Column(
                    children: [
                      inputField(l10n.salesStartingCash, startingCash),
                      const SizedBox(height: 12),
                      inputField(
                        l10n.salesTicketDeductionToday,
                        ticketDeductionController,
                        helperText: l10n.salesTicketDeductionHelper,
                      ),
                      const SizedBox(height: 12),
                      inputField(
                        l10n.salesActualCashCounted,
                        actualCashCounted,
                      ),
                    ],
                  ),
                ),
                sectionCard(
                  title: l10n.salesProductsTitle,
                  subtitle: l10n.salesProductsSubtitle,
                  child: Column(
                    children: [
                      productCard(
                        title: l10n.salesProductChickenLarge,
                        priceLabel: l10n.salesPriceEach(
                          pesoFormat.format(chickenLargePrice),
                        ),
                        beginningController: chickenLargeBeginning,
                        deliveredController: chickenLargeDelivered,
                        remainingController: chickenLargeRemaining,
                        soldQty: soldChickenLarge,
                        lineSales: chickenLargeLineSales,
                      ),
                      productCard(
                        title: l10n.salesProductChickenSmall,
                        priceLabel: l10n.salesPriceEach(
                          pesoFormat.format(chickenSmallPrice),
                        ),
                        beginningController: chickenSmallBeginning,
                        deliveredController: chickenSmallDelivered,
                        remainingController: chickenSmallRemaining,
                        soldQty: soldChickenSmall,
                        lineSales: chickenSmallLineSales,
                      ),
                      productCard(
                        title: l10n.salesProductLumpia,
                        priceLabel: l10n.salesPriceEach(
                          pesoFormat.format(lumpiaPrice),
                        ),
                        beginningController: lumpiaBeginning,
                        deliveredController: lumpiaDelivered,
                        remainingController: lumpiaRemaining,
                        soldQty: soldLumpia,
                        lineSales: lumpiaLineSales,
                      ),
                      riceCard(),
                    ],
                  ),
                ),
                validationCard(),
                totalsCard(),
                actionButtons(),
              ],
            ),
    );
  }
}
