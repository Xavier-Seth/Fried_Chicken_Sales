import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const SalesApp());
}

class SalesApp extends StatelessWidget {
  const SalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulador ng Benta ng Manok',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF59E0B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const SalesPage(),
    );
  }
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
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

  void calculateSales({bool showModal = false}) {
    final startCash = int.tryParse(startingCash.text) ?? 0;
    final actualCash = int.tryParse(actualCashCounted.text) ?? 0;

    final c20b = int.tryParse(chicken20Beginning.text) ?? 0;
    final c20d = int.tryParse(chicken20Delivered.text) ?? 0;
    final c20r = int.tryParse(chicken20Remaining.text) ?? 0;

    final c10b = int.tryParse(chicken10Beginning.text) ?? 0;
    final c10d = int.tryParse(chicken10Delivered.text) ?? 0;
    final c10r = int.tryParse(chicken10Remaining.text) ?? 0;

    final lb = int.tryParse(lumpiaBeginning.text) ?? 0;
    final ld = int.tryParse(lumpiaDelivered.text) ?? 0;
    final lr = int.tryParse(lumpiaRemaining.text) ?? 0;

    final rd = int.tryParse(riceDelivered.text) ?? 0;
    final rr = int.tryParse(riceRemaining.text) ?? 0;

    final safeSoldChicken20 = ((c20b + c20d) - c20r).clamp(0, 999999);
    final safeSoldChicken10 = ((c10b + c10d) - c10r).clamp(0, 999999);
    final safeSoldLumpia = ((lb + ld) - lr).clamp(0, 999999);
    final safeSoldRice = (rd - rr).clamp(0, 999999);

    final sales =
        (safeSoldChicken20 * 20) +
        (safeSoldChicken10 * 10) +
        (safeSoldLumpia * 5) +
        (safeSoldRice * 10);

    final computedExpectedCash = startCash + sales;
    final computedDifference = actualCash - computedExpectedCash;

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
    if (cashDifference < 0) return Colors.red;
    if (cashDifference > 0) return Colors.green;
    return const Color(0xFF202431);
  }

  String differenceLabel() {
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

  Widget sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF202431),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget productCard({
    required String title,
    required String subtitle,
    required IconData icon,
    TextEditingController? beginning,
    required TextEditingController delivered,
    required TextEditingController remaining,
    String deliveredLabel = 'Naideliver',
    String remainingLabel = 'Natira',
    String? soldText,
    String? salesText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFFF59E0B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202431),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A8194),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (beginning != null) ...[
            inputField('Panimulang Stock', beginning),
            const SizedBox(height: 12),
          ],
          inputField(deliveredLabel, delivered),
          const SizedBox(height: 12),
          inputField(remainingLabel, remaining),
          if (soldText != null || salesText != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E8EF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (soldText != null)
                    Text(
                      soldText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF202431),
                      ),
                    ),
                  if (salesText != null)
                    Text(
                      salesText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget summaryTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(46),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget breakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
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
      ),
    );
  }

  Widget salesBreakdownCard() {
    final countedCashValue = int.tryParse(actualCashCounted.text) ?? 0;

    return Container(
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
          const Text(
            'Detalye ng Benta',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202431),
            ),
          ),
          const SizedBox(height: 14),
          breakdownRow('Nabentang Manok ₱20', soldChicken20.toString()),
          breakdownRow('Nabentang Manok ₱10', soldChicken10.toString()),
          breakdownRow('Nabentang Lumpia', soldLumpia.toString()),
          breakdownRow('Nabentang Kanin', soldRice.toString()),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          breakdownRow('Kabuuang Benta', pesoFormat.format(totalSales)),
          breakdownRow('Inaasahang Pera', pesoFormat.format(expectedCash)),
          breakdownRow(
            'Aktwal na Nabilang na Pera',
            pesoFormat.format(countedCashValue),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: differenceColor().withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: differenceColor().withAlpha(60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pagkakaiba (${differenceLabel()})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: differenceColor(),
                  ),
                ),
                Text(
                  pesoFormat.format(cashDifference),
                  style: TextStyle(
                    fontSize: 18,
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

  @override
  Widget build(BuildContext context) {
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'reset') {
                confirmReset();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'reset',
                child: Text('I-reset ang Input'),
              ),
            ],
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
                        summaryTile(
                          'Kabuuang Benta',
                          pesoFormat.format(totalSales),
                          Icons.payments_rounded,
                        ),
                        const SizedBox(width: 12),
                        summaryTile(
                          'Inaasahang Pera',
                          pesoFormat.format(expectedCash),
                          Icons.account_balance_wallet_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              sectionCard(
                icon: Icons.attach_money_rounded,
                title: 'Panimulang Pera',
                child: inputField('Ilagay ang panimulang pera', startingCash),
              ),
              sectionCard(
                icon: Icons.point_of_sale_rounded,
                title: 'Bilang ng Pera',
                child: inputField(
                  'Ilagay ang aktwal na nabilang na pera',
                  actualCashCounted,
                ),
              ),
              productCard(
                title: 'Manok ₱20',
                subtitle: 'Subaybayan ang benta ng manok',
                icon: Icons.restaurant_rounded,
                beginning: chicken20Beginning,
                delivered: chicken20Delivered,
                remaining: chicken20Remaining,
                soldText: 'Nabenta: $soldChicken20',
                salesText: pesoFormat.format(soldChicken20 * 20),
              ),
              productCard(
                title: 'Manok ₱10',
                subtitle: 'Subaybayan ang benta ng regular na manok',
                icon: Icons.lunch_dining_rounded,
                beginning: chicken10Beginning,
                delivered: chicken10Delivered,
                remaining: chicken10Remaining,
                soldText: 'Nabenta: $soldChicken10',
                salesText: pesoFormat.format(soldChicken10 * 10),
              ),
              productCard(
                title: 'Lumpia ₱5',
                subtitle: 'Subaybayan ang galaw ng stock ng lumpia',
                icon: Icons.fastfood_rounded,
                beginning: lumpiaBeginning,
                delivered: lumpiaDelivered,
                remaining: lumpiaRemaining,
                soldText: 'Nabenta: $soldLumpia',
                salesText: pesoFormat.format(soldLumpia * 5),
              ),
              productCard(
                title: 'Kanin ₱10',
                subtitle: 'Sariwang niluluto araw-araw',
                icon: Icons.rice_bowl_rounded,
                delivered: riceDelivered,
                remaining: riceRemaining,
                deliveredLabel: 'Nalutong Kanin',
                remainingLabel: 'Natirang Kanin',
                soldText: 'Nabenta: $soldRice',
                salesText: pesoFormat.format(soldRice * 10),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => calculateSales(showModal: true),
                  icon: const Icon(Icons.calculate_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Kalkulahin ang Benta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF202431),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              salesBreakdownCard(),
            ],
          ),
        ),
      ),
    );
  }
}
