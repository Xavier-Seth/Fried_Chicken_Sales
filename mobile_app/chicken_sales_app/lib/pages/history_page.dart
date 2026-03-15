import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/sales_record.dart';
import '../services/sales_refresh_notifier.dart';
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
    SalesRefreshNotifier.refreshKey.addListener(_handleRefresh);
    loadRecords();
  }

  void _handleRefresh() {
    loadRecords();
  }

  Future<void> loadRecords() async {
    final data = await SalesStorage.getRecords();

    if (!mounted) return;

    setState(() {
      records = data;
      isLoading = false;
    });
  }

  Future<void> deleteItem(String id) async {
    await SalesStorage.deleteRecord(id);
    await loadRecords();
    SalesRefreshNotifier.notifyRefresh();
  }

  Future<void> clearAllRecords() async {
    await SalesStorage.clearAll();
    await loadRecords();
    SalesRefreshNotifier.notifyRefresh();
  }

  Future<void> confirmDelete(SalesRecord record) async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.historyDeleteRecordTitle),
          content: Text(l10n.historyDeleteRecordMessage(record.businessDate)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.commonDelete),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteItem(record.id);
    }
  }

  Future<void> confirmClearAll() async {
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.historyDeleteAllTitle),
          content: Text(l10n.historyDeleteAllMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.historyDeleteAllConfirm),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await clearAllRecords();
    }
  }

  Color differenceColor(int value) {
    if (value < 0) return Colors.red;
    if (value > 0) return Colors.green;
    return const Color(0xFF0F172A);
  }

  String differenceLabel(int value) {
    final l10n = AppLocalizations.of(context);

    if (value < 0) return l10n.historyStatusShort;
    if (value > 0) return l10n.historyStatusOver;
    return l10n.historyStatusMatch;
  }

  int get totalDays => records.length;

  int get totalGrossSales =>
      records.fold(0, (sum, item) => sum + item.grossSales);

  int get totalNetSales => records.fold(0, (sum, item) => sum + item.netSales);

  int get totalTicketDeduction =>
      records.fold(0, (sum, item) => sum + item.ticketDeduction);

  Widget topSummary() {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l10n.historyOverviewTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.historyDaysCount(totalDays),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: summaryItem(
                  l10n.historySummaryNet,
                  pesoFormat.format(totalNetSales),
                ),
              ),
              Expanded(
                child: summaryItem(
                  l10n.historySummaryGross,
                  pesoFormat.format(totalGrossSales),
                ),
              ),
              Expanded(
                child: summaryItem(
                  l10n.historySummaryTicket,
                  pesoFormat.format(totalTicketDeduction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget rowInfo(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget recordCard(SalesRecord record) {
    final l10n = AppLocalizations.of(context);
    final statusColor = differenceColor(record.difference);
    final statusLabel = differenceLabel(record.difference);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x11000000),
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.businessDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => confirmDelete(record),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 6),
          rowInfo(l10n.historyRowGross, pesoFormat.format(record.grossSales)),
          rowInfo(
            l10n.historyRowTicket,
            pesoFormat.format(record.ticketDeduction),
          ),
          rowInfo(l10n.historyRowNet, pesoFormat.format(record.netSales)),
          rowInfo(
            l10n.historyRowExpected,
            pesoFormat.format(record.expectedCash),
          ),
          rowInfo(l10n.historyRowActual, pesoFormat.format(record.actualCash)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  pesoFormat.format(record.difference),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
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
    final l10n = AppLocalizations.of(context);
    return Center(child: Text(l10n.historyEmptyTitle));
  }

  @override
  void dispose() {
    SalesRefreshNotifier.refreshKey.removeListener(_handleRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(l10n.historyAppBarTitle),
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        actions: [
          if (records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: confirmClearAll,
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return recordCard(records[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
