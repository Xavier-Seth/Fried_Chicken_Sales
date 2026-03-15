import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/sales_record.dart';
import '../services/sales_refresh_notifier.dart';
import '../services/sales_storage.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage>
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

  List<SalesRecord> get chartRecords {
    final list = [...records];
    list.sort((a, b) => a.businessDate.compareTo(b.businessDate));
    if (list.length > 7) {
      return list.sublist(list.length - 7);
    }
    return list;
  }

  int get totalNetSales => records.fold(0, (sum, item) => sum + item.netSales);

  int get totalGrossSales =>
      records.fold(0, (sum, item) => sum + item.grossSales);

  int get highestNetSale => records.isEmpty
      ? 0
      : records.map((e) => e.netSales).reduce((a, b) => a > b ? a : b);

  Widget compactMainStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(26)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget compactMiniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(22)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: Colors.white70),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                '$label: $value',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heroCard() {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26F59E0B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chartsHeroTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.chartsHeroSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withAlpha(24)),
                ),
                child: Text(
                  l10n.chartsDaysSaved(records.length),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              compactMainStat(
                icon: Icons.bar_chart_rounded,
                label: l10n.chartsHighestNet,
                value: pesoFormat.format(highestNetSale),
              ),
              const SizedBox(width: 8),
              compactMainStat(
                icon: Icons.payments_rounded,
                label: l10n.chartsTotalNet,
                value: pesoFormat.format(totalNetSales),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              compactMiniStat(
                icon: Icons.sell_rounded,
                label: l10n.chartsGross,
                value: pesoFormat.format(totalGrossSales),
              ),
              const SizedBox(width: 8),
              compactMiniStat(
                icon: Icons.calendar_month_rounded,
                label: l10n.chartsSaved,
                value: '${records.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_chart_outlined_rounded,
              size: 72,
              color: Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.chartsEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chartsEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: loadRecords,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.chartsRefresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartCard() {
    final l10n = AppLocalizations.of(context);

    if (chartRecords.isEmpty) return emptyState();

    final int maxValue = chartRecords
        .map((e) => e.netSales)
        .reduce((a, b) => a > b ? a : b);

    final double maxChartY = maxValue <= 0
        ? 100.0
        : (maxValue * 1.25).ceilToDouble();

    final double chartWidth = chartRecords.length < 7
        ? 360.0
        : (chartRecords.length * 72).toDouble();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        heroCard(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                l10n.chartsNetSalesChartTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.chartsLastSavedDays(chartRecords.length),
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      maxY: maxChartY,
                      alignment: BarChartAlignment.spaceAround,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxChartY / 4,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: Color(0xFFE5E7EB),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            interval: maxChartY / 4,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  '₱${value.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= chartRecords.length) {
                                return const SizedBox.shrink();
                              }

                              final raw = chartRecords[index].businessDate;
                              DateTime? parsed;
                              try {
                                parsed = DateTime.parse(raw);
                              } catch (_) {}

                              final label = parsed != null
                                  ? DateFormat('MM/dd').format(parsed)
                                  : raw;

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => const Color(0xFF0F172A),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final record = chartRecords[group.x.toInt()];
                            return BarTooltipItem(
                              '${record.businessDate}\n${pesoFormat.format(record.netSales)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                      barGroups: List.generate(chartRecords.length, (index) {
                        final record = chartRecords[index];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: record.netSales.toDouble(),
                              width: 20,
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
        title: Text(
          l10n.chartsAppBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chartCard(),
    );
  }
}
