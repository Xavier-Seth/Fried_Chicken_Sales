import 'package:flutter/material.dart';

class CashStatusCard extends StatelessWidget {
  final int cashDifference;
  final String formattedDifference;

  const CashStatusCard({
    super.key,
    required this.cashDifference,
    required this.formattedDifference,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData icon;
    Color color;

    if (cashDifference == 0) {
      title = 'Tugma ang Pera';
      subtitle = 'Walang diperensya sa bilang ng pera.';
      icon = Icons.check_circle_rounded;
      color = Colors.green;
    } else if (cashDifference < 0) {
      title = 'Kulang ang Pera';
      subtitle = 'May kulang na $formattedDifference.';
      icon = Icons.error_rounded;
      color = Colors.red;
    } else {
      title = 'Sobra ang Pera';
      subtitle = 'May sobrang $formattedDifference.';
      icon = Icons.warning_rounded;
      color = Colors.orange;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5C6475),
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
