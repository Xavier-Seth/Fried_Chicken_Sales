import 'package:flutter/material.dart';

class SalesBreakdownCard extends StatelessWidget {
  final int soldChicken20;
  final int soldChicken10;
  final int soldLumpia;
  final int soldRice;
  final String totalSalesText;
  final String expectedCashText;
  final String countedCashText;
  final String cashDifferenceText;
  final String differenceLabel;
  final Color differenceColor;

  const SalesBreakdownCard({
    super.key,
    required this.soldChicken20,
    required this.soldChicken10,
    required this.soldLumpia,
    required this.soldRice,
    required this.totalSalesText,
    required this.expectedCashText,
    required this.countedCashText,
    required this.cashDifferenceText,
    required this.differenceLabel,
    required this.differenceColor,
  });

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

  @override
  Widget build(BuildContext context) {
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
          breakdownRow('Kabuuang Benta', totalSalesText),
          breakdownRow('Inaasahang Pera', expectedCashText),
          breakdownRow('Aktwal na Nabilang na Pera', countedCashText),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: differenceColor.withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: differenceColor.withAlpha(60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pagkakaiba ($differenceLabel)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: differenceColor,
                  ),
                ),
                Text(
                  cashDifferenceText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: differenceColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
