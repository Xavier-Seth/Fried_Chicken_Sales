import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_record.dart';
import '../services/sales_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  final pesoFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 0,
  );

  List<SalesRecord> records = [];
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    final data = await SalesStorage.getRecords();

    data.sort((a, b) => b.businessDate.compareTo(a.businessDate));

    if (!mounted) return;

    setState(() {
      records = data;
      isLoading = false;
    });
  }

  Future<void> deleteItem(String id) async {
    await SalesStorage.deleteRecord(id);
    await loadRecords();
  }

  Future<void> clearAllRecords() async {
    await SalesStorage.clearAll();
    await loadRecords();
  }

  Future<void> confirmDelete(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete this record?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('This sales record will be permanently removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteItem(id);
    }
  }

  Future<void> confirmClearAll() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete all history?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'All saved sales records will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await clearAllRecords();
    }
  }

  Color differenceColor(int difference, int actualCash) {
    if (actualCash == 0) return const Color(0xFF64748B);
    if (difference < 0) return Colors.red;
    if (difference > 0) return Colors.orange;
    return Colors.green;
  }

  String differenceLabel(int difference, int actualCash) {
    if (actualCash == 0) return 'Draft';
    if (difference < 0) return 'Short';
    if (difference > 0) return 'Over';
    return 'Matched';
  }

  IconData differenceIcon(int difference, int actualCash) {
    if (actualCash == 0) return Icons.edit_note_rounded;
    if (difference < 0) return Icons.error_rounded;
    if (difference > 0) return Icons.warning_rounded;
    return Icons.check_circle_rounded;
  }

  Widget infoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget recordCard(SalesRecord record) {
    final statusColor = differenceColor(record.difference, record.actualCash);
    final statusLabel = differenceLabel(record.difference, record.actualCash);
    final statusIcon = differenceIcon(record.difference, record.actualCash);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(statusIcon, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.businessDate.isNotEmpty
                          ? record.businessDate
                          : record.date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      record.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => confirmDelete(record.id),
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Sales',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  pesoFormat.format(record.totalSales),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          infoRow('Expected Cash', pesoFormat.format(record.expectedCash)),
          infoRow('Actual Cash', pesoFormat.format(record.actualCash)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withAlpha(60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: $statusLabel',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                Text(
                  pesoFormat.format(record.difference),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3DD),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 42,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No sales history yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saved daily records will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget topSummary() {
    final totalDays = records.length;
    final totalSalesAll = records.fold<int>(0, (sum, r) => sum + r.totalSales);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withAlpha(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Saved Days',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalDays',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withAlpha(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.payments_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'All-Time Sales',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pesoFormat.format(totalSalesAll),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget historyHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(
            'Daily Records',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Sales History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        actions: [
          if (!isLoading && records.isNotEmpty)
            IconButton(
              onPressed: confirmClearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Delete All',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
          ? emptyState()
          : Column(
              children: [
                topSummary(),
                historyHeader(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: loadRecords,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return recordCard(record);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
