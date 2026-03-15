class SalesRecord {
  final String id;
  final String businessDate;
  final String date;

  final int grossSales;
  final int netSales;
  final int totalSales;
  final int ticketDeduction;
  final int expectedCash;
  final int actualCash;
  final int difference;

  final int chickenLargePrice;
  final int chickenSmallPrice;
  final int lumpiaPrice;
  final int ricePrice;

  final int soldChickenLarge;
  final int soldChickenSmall;
  final int soldLumpia;
  final int soldRice;

  final String startingCashInput;
  final String actualCashCountedInput;

  final String chickenLargeBeginningInput;
  final String chickenLargeDeliveredInput;
  final String chickenLargeRemainingInput;

  final String chickenSmallBeginningInput;
  final String chickenSmallDeliveredInput;
  final String chickenSmallRemainingInput;

  final String lumpiaBeginningInput;
  final String lumpiaDeliveredInput;
  final String lumpiaRemainingInput;

  final String riceDeliveredInput;
  final String riceRemainingInput;

  const SalesRecord({
    required this.id,
    required this.businessDate,
    required this.date,
    required this.grossSales,
    required this.netSales,
    required this.totalSales,
    required this.ticketDeduction,
    required this.expectedCash,
    required this.actualCash,
    required this.difference,
    required this.chickenLargePrice,
    required this.chickenSmallPrice,
    required this.lumpiaPrice,
    required this.ricePrice,
    required this.soldChickenLarge,
    required this.soldChickenSmall,
    required this.soldLumpia,
    required this.soldRice,
    required this.startingCashInput,
    required this.actualCashCountedInput,
    required this.chickenLargeBeginningInput,
    required this.chickenLargeDeliveredInput,
    required this.chickenLargeRemainingInput,
    required this.chickenSmallBeginningInput,
    required this.chickenSmallDeliveredInput,
    required this.chickenSmallRemainingInput,
    required this.lumpiaBeginningInput,
    required this.lumpiaDeliveredInput,
    required this.lumpiaRemainingInput,
    required this.riceDeliveredInput,
    required this.riceRemainingInput,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessDate': businessDate,
      'date': date,
      'grossSales': grossSales,
      'netSales': netSales,
      'totalSales': totalSales,
      'ticketDeduction': ticketDeduction,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'difference': difference,
      'chickenLargePrice': chickenLargePrice,
      'chickenSmallPrice': chickenSmallPrice,
      'lumpiaPrice': lumpiaPrice,
      'ricePrice': ricePrice,
      'soldChickenLarge': soldChickenLarge,
      'soldChickenSmall': soldChickenSmall,
      'soldLumpia': soldLumpia,
      'soldRice': soldRice,
      'startingCashInput': startingCashInput,
      'actualCashCountedInput': actualCashCountedInput,
      'chickenLargeBeginningInput': chickenLargeBeginningInput,
      'chickenLargeDeliveredInput': chickenLargeDeliveredInput,
      'chickenLargeRemainingInput': chickenLargeRemainingInput,
      'chickenSmallBeginningInput': chickenSmallBeginningInput,
      'chickenSmallDeliveredInput': chickenSmallDeliveredInput,
      'chickenSmallRemainingInput': chickenSmallRemainingInput,
      'lumpiaBeginningInput': lumpiaBeginningInput,
      'lumpiaDeliveredInput': lumpiaDeliveredInput,
      'lumpiaRemainingInput': lumpiaRemainingInput,
      'riceDeliveredInput': riceDeliveredInput,
      'riceRemainingInput': riceRemainingInput,
    };
  }

  factory SalesRecord.fromMap(Map<String, dynamic> map) {
    final fallbackDate = (map['date'] ?? '').toString();
    final legacyTotalSales = (map['totalSales'] ?? 0) as int;
    final legacyGrossSales = (map['grossSales'] ?? legacyTotalSales) as int;
    final legacyNetSales = (map['netSales'] ?? legacyTotalSales) as int;

    return SalesRecord(
      id: (map['id'] ?? '').toString(),
      businessDate:
          (map['businessDate'] ??
                  (fallbackDate.length >= 10
                      ? fallbackDate.substring(0, 10)
                      : ''))
              .toString(),
      date: fallbackDate,
      grossSales: legacyGrossSales,
      netSales: legacyNetSales,
      totalSales: legacyNetSales,
      ticketDeduction: (map['ticketDeduction'] ?? 0) as int,
      expectedCash: (map['expectedCash'] ?? 0) as int,
      actualCash: (map['actualCash'] ?? 0) as int,
      difference: (map['difference'] ?? 0) as int,
      chickenLargePrice: (map['chickenLargePrice'] ?? 20) as int,
      chickenSmallPrice:
          (map['chickenSmallPrice'] ?? map['chicken10Price'] ?? 12) as int,
      lumpiaPrice: (map['lumpiaPrice'] ?? 5) as int,
      ricePrice: (map['ricePrice'] ?? 10) as int,
      soldChickenLarge:
          (map['soldChickenLarge'] ?? map['soldChicken20'] ?? 0) as int,
      soldChickenSmall:
          (map['soldChickenSmall'] ?? map['soldChicken10'] ?? 0) as int,
      soldLumpia: (map['soldLumpia'] ?? 0) as int,
      soldRice: (map['soldRice'] ?? 0) as int,
      startingCashInput: (map['startingCashInput'] ?? '').toString(),
      actualCashCountedInput: (map['actualCashCountedInput'] ?? '').toString(),
      chickenLargeBeginningInput:
          (map['chickenLargeBeginningInput'] ??
                  map['chicken20BeginningInput'] ??
                  '')
              .toString(),
      chickenLargeDeliveredInput:
          (map['chickenLargeDeliveredInput'] ??
                  map['chicken20DeliveredInput'] ??
                  '')
              .toString(),
      chickenLargeRemainingInput:
          (map['chickenLargeRemainingInput'] ??
                  map['chicken20RemainingInput'] ??
                  '')
              .toString(),
      chickenSmallBeginningInput:
          (map['chickenSmallBeginningInput'] ??
                  map['chicken10BeginningInput'] ??
                  '')
              .toString(),
      chickenSmallDeliveredInput:
          (map['chickenSmallDeliveredInput'] ??
                  map['chicken10DeliveredInput'] ??
                  '')
              .toString(),
      chickenSmallRemainingInput:
          (map['chickenSmallRemainingInput'] ??
                  map['chicken10RemainingInput'] ??
                  '')
              .toString(),
      lumpiaBeginningInput: (map['lumpiaBeginningInput'] ?? '').toString(),
      lumpiaDeliveredInput: (map['lumpiaDeliveredInput'] ?? '').toString(),
      lumpiaRemainingInput: (map['lumpiaRemainingInput'] ?? '').toString(),
      riceDeliveredInput: (map['riceDeliveredInput'] ?? '').toString(),
      riceRemainingInput: (map['riceRemainingInput'] ?? '').toString(),
    );
  }
}
