import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? beginningField;
  final Widget deliveredField;
  final Widget remainingField;
  final String? soldText;
  final String? salesText;

  const ProductCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.beginningField,
    required this.deliveredField,
    required this.remainingField,
    this.soldText,
    this.salesText,
  });

  @override
  Widget build(BuildContext context) {
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
          if (beginningField != null) ...[
            beginningField!,
            const SizedBox(height: 12),
          ],
          deliveredField,
          const SizedBox(height: 12),
          remainingField,
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
                      soldText!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF202431),
                      ),
                    ),
                  if (salesText != null)
                    Text(
                      salesText!,
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
}
