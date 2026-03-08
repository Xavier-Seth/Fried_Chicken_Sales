import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/sales_record.dart';
import '../services/sales_storage.dart';
import '../widgets/sales/cash_status_card.dart';
import '../widgets/sales/product_card.dart';
import '../widgets/sales/sales_breakdown_card.dart';
import '../widgets/sales/section_card.dart';
import '../widgets/sales/summary_tile.dart';
import '../widgets/sales/validation_card.dart';

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

  final chicken20Beginning = TextEditingController();
  final chicken20Delivered = TextEditingController();
  final chicken20Remaining = TextEditingController();

  final chicken10Beginning = TextEditingController();
  final chicken10Delivered = TextEditingController();
  final chicken10Remaining = TextEditingController();

  final lumpiaBeginning = TextEditingController();
  final lumpiaDelivered = TextEditingController();
  final lumpiaRemaining = TextEditingController();

  final riceDelivered = TextEditingController();
  final riceRemaining = TextEditingController();

  int soldChicken20 = 0;
  int soldChicken10 = 0;
  int soldLumpia = 0;
  int soldRice = 0;

  int totalSales = 0;
  int expectedCash = 0;
  int cashDifference = 0;

  bool hasSavedToday = false;
  bool isLoadingTodayRecord = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadTodayRecord();
  }

  String get todayBusinessDate =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  int parseValue(TextEditingController controller) {
    return int.tryParse(controller.text) ?? 0;
  }

  bool get hasActualCashInput => actualCashCounted.text.trim().isNotEmpty;

  bool hasNegativeValue(TextEditingController controller) {
    return controller.text.trim().startsWith('-');
  }

  bool get invalidChicken20 {
    final b = parseValue(chicken20Beginning);
    final d = parseValue(chicken20Delivered);
    final r = parseValue(chicken20Remaining);
    return r > (b + d) ||
        hasNegativeValue(chicken20Beginning) ||
        hasNegativeValue(chicken20Delivered) ||
        hasNegativeValue(chicken20Remaining);
  }

  bool get invalidChicken10 {
    final b = parseValue(chicken10Beginning);
    final d = parseValue(chicken10Delivered);
    final r = parseValue(chicken10Remaining);
    return r > (b + d) ||
        hasNegativeValue(chicken10Beginning) ||
        hasNegativeValue(chicken10Delivered) ||
        hasNegativeValue(chicken10Remaining);
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
    return invalidChicken20 || invalidChicken10 || invalidLumpia || invalidRice;
  }

  String getValidationMessage() {
    if (invalidChicken20) {
      return 'Chicken ₱20 is invalid. Remaining stock cannot be greater than beginning + delivered.';
    }
    if (invalidChicken10) {
      return 'Chicken ₱10 is invalid. Remaining stock cannot be greater than beginning + delivered.';
    }
    if (invalidLumpia) {
      return 'Lumpia is invalid. Remaining stock cannot be greater than beginning + delivered.';
    }
    if (invalidRice) {
      return 'Rice is invalid. Remaining rice cannot be greater than delivered rice.';
    }
    return '';
  }

  bool hasValue(TextEditingController controller) {
    return controller.text.trim().isNotEmpty;
  }

  int soldIfComplete({
    required int beginning,
    required int delivered,
    required TextEditingController remainingController,
  }) {
    if (!hasValue(remainingController)) return 0;
    final remaining = parseValue(remainingController);
    return ((beginning + delivered) - remaining).clamp(0, 999999);
  }

  int soldRiceIfComplete() {
    if (!hasValue(riceRemaining)) return 0;
    final delivered = parseValue(riceDelivered);
    final remaining = parseValue(riceRemaining);
    return (delivered - remaining).clamp(0, 999999);
  }

  void calculateSales({bool showModal = false}) {
    final startCash = int.tryParse(startingCash.text) ?? 0;
    final actualCash = int.tryParse(actualCashCounted.text) ?? 0;

    final c20b = int.tryParse(chicken20Beginning.text) ?? 0;
    final c20d = int.tryParse(chicken20Delivered.text) ?? 0;

    final c10b = int.tryParse(chicken10Beginning.text) ?? 0;
    final c10d = int.tryParse(chicken10Delivered.text) ?? 0;

    final lb = int.tryParse(lumpiaBeginning.text) ?? 0;
    final ld = int.tryParse(lumpiaDelivered.text) ?? 0;

    final safeSoldChicken20 = soldIfComplete(
      beginning: c20b,
      delivered: c20d,
      remainingController: chicken20Remaining,
    );
    final safeSoldChicken10 = soldIfComplete(
      beginning: c10b,
      delivered: c10d,
      remainingController: chicken10Remaining,
    );
    final safeSoldLumpia = soldIfComplete(
      beginning: lb,
      delivered: ld,
      remainingController: lumpiaRemaining,
    );
    final safeSoldRice = soldRiceIfComplete();

    final sales =
        (safeSoldChicken20 * 20) +
        (safeSoldChicken10 * 10) +
        (safeSoldLumpia * 5) +
        (safeSoldRice * 10);

    final computedExpectedCash = startCash + sales;
    final computedDifference = hasActualCashInput
        ? actualCash - computedExpectedCash
        : 0;

    setState(() {
      soldChicken20 = safeSoldChicken20;
      soldChicken10 = safeSoldChicken10;
      soldLumpia = safeSoldLumpia;
      soldRice = safeSoldRice;
      totalSales = sales;
      expectedCash = computedExpectedCash;
      cashDifference = computedDifference;
    });

    if (showModal) {
      showSalesResultModal();
    }
  }

  Future<void> loadTodayRecord() async {
    final record = await SalesStorage.getRecordByBusinessDate(
      todayBusinessDate,
    );

    if (!mounted) return;

    if (record != null) {
      startingCash.text = record.startingCashInput;
      actualCashCounted.text = record.actualCashCountedInput;

      chicken20Beginning.text = record.chicken20BeginningInput;
      chicken20Delivered.text = record.chicken20DeliveredInput;
      chicken20Remaining.text = record.chicken20RemainingInput;

      chicken10Beginning.text = record.chicken10BeginningInput;
      chicken10Delivered.text = record.chicken10DeliveredInput;
      chicken10Remaining.text = record.chicken10RemainingInput;

      lumpiaBeginning.text = record.lumpiaBeginningInput;
      lumpiaDelivered.text = record.lumpiaDeliveredInput;
      lumpiaRemaining.text = record.lumpiaRemainingInput;

      riceDelivered.text = record.riceDeliveredInput;
      riceRemaining.text = record.riceRemainingInput;
    }

    setState(() {
      hasSavedToday = record != null;
      isLoadingTodayRecord = false;
    });

    calculateSales();
  }

  SalesRecord buildTodayRecord() {
    final now = DateTime.now();

    return SalesRecord(
      id: todayBusinessDate,
      businessDate: todayBusinessDate,
      date: DateFormat('yyyy-MM-dd – hh:mm a').format(now),
      totalSales: totalSales,
      expectedCash: expectedCash,
      actualCash: int.tryParse(actualCashCounted.text) ?? 0,
      difference: cashDifference,
      startingCashInput: startingCash.text.trim(),
      actualCashCountedInput: actualCashCounted.text.trim(),
      chicken20BeginningInput: chicken20Beginning.text.trim(),
      chicken20DeliveredInput: chicken20Delivered.text.trim(),
      chicken20RemainingInput: chicken20Remaining.text.trim(),
      chicken10BeginningInput: chicken10Beginning.text.trim(),
      chicken10DeliveredInput: chicken10Delivered.text.trim(),
      chicken10RemainingInput: chicken10Remaining.text.trim(),
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

    chicken20Beginning.clear();
    chicken20Delivered.clear();
    chicken20Remaining.clear();

    chicken10Beginning.clear();
    chicken10Delivered.clear();
    chicken10Remaining.clear();

    lumpiaBeginning.clear();
    lumpiaDelivered.clear();
    lumpiaRemaining.clear();

    riceDelivered.clear();
    riceRemaining.clear();

    setState(() {
      soldChicken20 = 0;
      soldChicken10 = 0;
      soldLumpia = 0;
      soldRice = 0;
      totalSales = 0;
      expectedCash = 0;
      cashDifference = 0;
      hasSavedToday = false;
    });
  }

  Future<void> confirmReset() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('I-reset ang mga input?'),
          content: const Text(
            'Mawawala ang lahat ng laman ng fields at mare-reset ang buod ng benta.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Kanselahin'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('I-reset'),
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
    final countedCashValue = int.tryParse(actualCashCounted.text) ?? 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Resulta ng Benta',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              modalRow('Kabuuang Benta', pesoFormat.format(totalSales)),
              const SizedBox(height: 10),
              modalRow('Inaasahang Pera', pesoFormat.format(expectedCash)),
              const SizedBox(height: 10),
              modalRow('Aktwal na Pera', pesoFormat.format(countedCashValue)),
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
                    Text(
                      'Pagkakaiba (${differenceLabel()})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: differenceColor(),
                      ),
                    ),
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Color differenceColor() {
    if (!hasActualCashInput) return const Color(0xFF202431);
    if (cashDifference < 0) return Colors.red;
    if (cashDifference > 0) return Colors.green;
    return const Color(0xFF202431);
  }

  String differenceLabel() {
    if (!hasActualCashInput) return 'Wala Pa';
    if (cashDifference < 0) return 'Kulang';
    if (cashDifference > 0) return 'Sobra';
    return 'Tugma';
  }

  InputDecoration modernInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      labelStyle: const TextStyle(color: Color(0xFF7A8194), fontSize: 14),
    );
  }

  Widget inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => calculateSales(),
      decoration: modernInputDecoration(label),
    );
  }

  Widget modalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF5C6475)),
        ),
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

  @override
  void dispose() {
    startingCash.dispose();
    actualCashCounted.dispose();

    chicken20Beginning.dispose();
    chicken20Delivered.dispose();
    chicken20Remaining.dispose();

    chicken10Beginning.dispose();
    chicken10Delivered.dispose();
    chicken10Remaining.dispose();

    lumpiaBeginning.dispose();
    lumpiaDelivered.dispose();
    lumpiaRemaining.dispose();

    riceDelivered.dispose();
    riceRemaining.dispose();

    super.dispose();
  }

  Future<void> saveCurrentRecord() async {
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

    if (startingCash.text.trim().isEmpty &&
        actualCashCounted.text.trim().isEmpty &&
        chicken20Beginning.text.trim().isEmpty &&
        chicken20Delivered.text.trim().isEmpty &&
        chicken20Remaining.text.trim().isEmpty &&
        chicken10Beginning.text.trim().isEmpty &&
        chicken10Delivered.text.trim().isEmpty &&
        chicken10Remaining.text.trim().isEmpty &&
        lumpiaBeginning.text.trim().isEmpty &&
        lumpiaDelivered.text.trim().isEmpty &&
        lumpiaRemaining.text.trim().isEmpty &&
        riceDelivered.text.trim().isEmpty &&
        riceRemaining.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least some data before saving.'),
        ),
      );
      return;
    }

    final wasSavedToday = hasSavedToday;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            wasSavedToday ? 'Update today’s record?' : 'Save today’s record?',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              modalRow('Kabuuang Benta', pesoFormat.format(totalSales)),
              const SizedBox(height: 10),
              modalRow('Inaasahang Pera', pesoFormat.format(expectedCash)),
              const SizedBox(height: 10),
              modalRow(
                'Aktwal na Pera',
                pesoFormat.format(int.tryParse(actualCashCounted.text) ?? 0),
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
                    Text(
                      'Pagkakaiba (${differenceLabel()})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: differenceColor(),
                      ),
                    ),
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
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Kanselahin'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(wasSavedToday ? 'Update' : 'Save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final record = buildTodayRecord();
    await SalesStorage.saveOrUpdateRecord(record);

    if (!mounted) return;

    setState(() {
      hasSavedToday = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasSavedToday
              ? 'Today’s record has been updated.'
              : 'Today’s record has been saved.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final countedCashValue = int.tryParse(actualCashCounted.text) ?? 0;

    if (isLoadingTodayRecord) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Arawang Benta',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        actions: [
          if (hasSavedToday)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Saved Today',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
                      color: Color(0x33F59E0B),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buod ng Araw',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        SummaryTile(
                          label: 'Kabuuang Benta',
                          value: pesoFormat.format(totalSales),
                          icon: Icons.payments_rounded,
                        ),
                        const SizedBox(width: 12),
                        SummaryTile(
                          label: 'Inaasahang Pera',
                          value: pesoFormat.format(expectedCash),
                          icon: Icons.account_balance_wallet_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CashStatusCard(
                cashDifference: cashDifference,
                formattedDifference: pesoFormat.format(cashDifference.abs()),
              ),
              ValidationCard(
                visible: hasInvalidStock,
                message: getValidationMessage(),
              ),
              SectionCard(
                icon: Icons.attach_money_rounded,
                title: 'Panimulang Pera',
                child: inputField('Ilagay ang panimulang pera', startingCash),
              ),
              SectionCard(
                icon: Icons.point_of_sale_rounded,
                title: 'Bilang ng Pera',
                child: inputField(
                  'Ilagay ang aktwal na nabilang na pera',
                  actualCashCounted,
                ),
              ),
              ProductCard(
                title: 'Manok ₱20',
                subtitle: 'Subaybayan ang benta ng manok',
                icon: Icons.restaurant_rounded,
                beginningField: inputField(
                  'Panimulang Stock',
                  chicken20Beginning,
                ),
                deliveredField: inputField('Naideliver', chicken20Delivered),
                remainingField: inputField('Natira', chicken20Remaining),
                soldText: 'Nabenta: $soldChicken20',
                salesText: pesoFormat.format(soldChicken20 * 20),
              ),
              ProductCard(
                title: 'Manok ₱10',
                subtitle: 'Subaybayan ang benta ng regular na manok',
                icon: Icons.lunch_dining_rounded,
                beginningField: inputField(
                  'Panimulang Stock',
                  chicken10Beginning,
                ),
                deliveredField: inputField('Naideliver', chicken10Delivered),
                remainingField: inputField('Natira', chicken10Remaining),
                soldText: 'Nabenta: $soldChicken10',
                salesText: pesoFormat.format(soldChicken10 * 10),
              ),
              ProductCard(
                title: 'Lumpia ₱5',
                subtitle: 'Subaybayan ang galaw ng stock ng lumpia',
                icon: Icons.fastfood_rounded,
                beginningField: inputField('Panimulang Stock', lumpiaBeginning),
                deliveredField: inputField('Naideliver', lumpiaDelivered),
                remainingField: inputField('Natira', lumpiaRemaining),
                soldText: 'Nabenta: $soldLumpia',
                salesText: pesoFormat.format(soldLumpia * 5),
              ),
              ProductCard(
                title: 'Kanin ₱10',
                subtitle: 'Sariwang niluluto araw-araw',
                icon: Icons.rice_bowl_rounded,
                deliveredField: inputField('Nalutong Kanin', riceDelivered),
                remainingField: inputField('Natirang Kanin', riceRemaining),
                soldText: 'Nabenta: $soldRice',
                salesText: pesoFormat.format(soldRice * 10),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: saveCurrentRecord,
                  icon: const Icon(Icons.save_rounded),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      hasSavedToday ? 'Update Today' : 'Save Today',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SalesBreakdownCard(
                soldChicken20: soldChicken20,
                soldChicken10: soldChicken10,
                soldLumpia: soldLumpia,
                soldRice: soldRice,
                totalSalesText: pesoFormat.format(totalSales),
                expectedCashText: pesoFormat.format(expectedCash),
                countedCashText: pesoFormat.format(countedCashValue),
                cashDifferenceText: pesoFormat.format(cashDifference),
                differenceLabel: differenceLabel(),
                differenceColor: differenceColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
