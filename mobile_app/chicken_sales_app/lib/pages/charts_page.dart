import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_record.dart';
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
    loadRecords();
  }

  Future<void> loadRecords() async {
    final data = await SalesStorage.getRecords();
    data.sort((a, b) => a.businessDate.compareTo(b.businessDate));

    if (!mounted) return;

    setState(() {
      records = data;
      isLoading = false;
    });
  }

  List<SalesRecord> get recentChartRecords {
    if (records.length <= 7) return records;
    return records.sublist(records.length - 7);
  }

  double get maxChartY {
    if (recentChartRecords.isEmpty) return 100;

    final maxValue = recentChartRecords
        .map((r) => r.totalSales.toDouble())
        .reduce((a, b) => a > b ? a : b);

    if (maxValue <= 0) return 100;
    return (maxValue * 1.25).ceilToDouble();
  }

  Widget summaryCard() {
    final totalDays = records.length;
    final totalSales = records.fold<int>(
      0,
      (sum, item) => sum + item.totalSales,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
            child: _summaryTile(
              icon: Icons.calendar_month_rounded,
              label: 'Saved Days',
              value: '$totalDays',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _summaryTile(
              icon: Icons.payments_rounded,
              label: 'All-Time Sales',
              value: pesoFormat.format(totalSales),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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
                Icons.bar_chart_rounded,
                size: 42,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No chart data yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save daily sales records first to see analytics here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartCard() {
    final chartRecords = recentChartRecords;

    if (chartRecords.isEmpty) {
      return emptyState();
    }

    final chartWidth = (chartRecords.length * 72).toDouble().clamp(
      420.0,
      700.0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          summaryCard(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
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
                  'Sales Chart',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Last 7 saved days',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    height: 280,
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
                              reservedSize: 48,
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
                              reservedSize: 36,
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
                                '${record.businessDate}\n${pesoFormat.format(record.totalSales)}',
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
                                toY: record.totalSales.toDouble(),
                                width: 22,
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF59E0B),
                                    Color(0xFFF97316),
                                  ],
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
          'Sales Charts',
          style: TextStyle(fontWeight: FontWeight.w700),
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
