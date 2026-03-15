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

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

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

    final legacyTotalSales = _toInt(map['totalSales']);
    final legacyGrossSales = _toInt(
      map['grossSales'],
      fallback: legacyTotalSales,
    );
    final legacyNetSales = _toInt(map['netSales'], fallback: legacyTotalSales);

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
      ticketDeduction: _toInt(map['ticketDeduction']),
      expectedCash: _toInt(map['expectedCash']),
      actualCash: _toInt(map['actualCash']),
      difference: _toInt(map['difference']),
      chickenLargePrice: _toInt(map['chickenLargePrice'], fallback: 20),
      chickenSmallPrice: _toInt(
        map['chickenSmallPrice'] ?? map['chicken10Price'],
        fallback: 12,
      ),
      lumpiaPrice: _toInt(map['lumpiaPrice'], fallback: 5),
      ricePrice: _toInt(map['ricePrice'], fallback: 10),
      soldChickenLarge: _toInt(map['soldChickenLarge'] ?? map['soldChicken20']),
      soldChickenSmall: _toInt(map['soldChickenSmall'] ?? map['soldChicken10']),
      soldLumpia: _toInt(map['soldLumpia']),
      soldRice: _toInt(map['soldRice']),
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
