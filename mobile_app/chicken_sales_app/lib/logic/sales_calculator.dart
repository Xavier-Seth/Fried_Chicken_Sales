class SalesCalculationResult {
  final int soldChickenLarge;
  final int soldChickenSmall;
  final int soldLumpia;
  final int soldRice;

  final int chickenLargeSales;
  final int chickenSmallSales;
  final int lumpiaSales;
  final int riceSales;

  final int grossSales;
  final int ticketDeduction;
  final int netSales;
  final int expectedCash;
  final int actualCash;
  final int cashDifference;

  const SalesCalculationResult({
    required this.soldChickenLarge,
    required this.soldChickenSmall,
    required this.soldLumpia,
    required this.soldRice,
    required this.chickenLargeSales,
    required this.chickenSmallSales,
    required this.lumpiaSales,
    required this.riceSales,
    required this.grossSales,
    required this.ticketDeduction,
    required this.netSales,
    required this.expectedCash,
    required this.actualCash,
    required this.cashDifference,
  });
}

class SalesCalculator {
  static int parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  static int soldFromStock({
    required int beginning,
    required int delivered,
    required int remaining,
  }) {
    final result = (beginning + delivered) - remaining;
    return result < 0 ? 0 : result;
  }

  static int soldRice({required int delivered, required int remaining}) {
    final result = delivered - remaining;
    return result < 0 ? 0 : result;
  }

  static SalesCalculationResult calculate({
    required int startingCash,
    required int actualCash,
    required bool hasActualCashInput,
    required int chickenLargeBeginning,
    required int chickenLargeDelivered,
    required int chickenLargeRemaining,
    required int chickenSmallBeginning,
    required int chickenSmallDelivered,
    required int chickenSmallRemaining,
    required int lumpiaBeginning,
    required int lumpiaDelivered,
    required int lumpiaRemaining,
    required int riceDelivered,
    required int riceRemaining,
    required int chickenLargePrice,
    required int chickenSmallPrice,
    required int lumpiaPrice,
    required int ricePrice,
    required int ticketDeduction,
  }) {
    final soldChickenLarge = soldFromStock(
      beginning: chickenLargeBeginning,
      delivered: chickenLargeDelivered,
      remaining: chickenLargeRemaining,
    );

    final soldChickenSmall = soldFromStock(
      beginning: chickenSmallBeginning,
      delivered: chickenSmallDelivered,
      remaining: chickenSmallRemaining,
    );

    final soldLumpia = soldFromStock(
      beginning: lumpiaBeginning,
      delivered: lumpiaDelivered,
      remaining: lumpiaRemaining,
    );

    final soldRiceValue = soldRice(
      delivered: riceDelivered,
      remaining: riceRemaining,
    );

    final chickenLargeSales = soldChickenLarge * chickenLargePrice;
    final chickenSmallSales = soldChickenSmall * chickenSmallPrice;
    final lumpiaSales = soldLumpia * lumpiaPrice;
    final riceSales = soldRiceValue * ricePrice;

    final grossSales =
        chickenLargeSales + chickenSmallSales + lumpiaSales + riceSales;

    final safeTicketDeduction = ticketDeduction < 0 ? 0 : ticketDeduction;
    final netSales = grossSales - safeTicketDeduction < 0
        ? 0
        : grossSales - safeTicketDeduction;

    final expectedCash = startingCash + netSales;
    final cashDifference = hasActualCashInput ? actualCash - expectedCash : 0;

    return SalesCalculationResult(
      soldChickenLarge: soldChickenLarge,
      soldChickenSmall: soldChickenSmall,
      soldLumpia: soldLumpia,
      soldRice: soldRiceValue,
      chickenLargeSales: chickenLargeSales,
      chickenSmallSales: chickenSmallSales,
      lumpiaSales: lumpiaSales,
      riceSales: riceSales,
      grossSales: grossSales,
      ticketDeduction: safeTicketDeduction,
      netSales: netSales,
      expectedCash: expectedCash,
      actualCash: actualCash,
      cashDifference: cashDifference,
    );
  }
}
