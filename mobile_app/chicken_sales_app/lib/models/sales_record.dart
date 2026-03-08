class SalesRecord {
  final String id;
  final String businessDate;
  final String date;

  final int totalSales;
  final int expectedCash;
  final int actualCash;
  final int difference;

  final String startingCashInput;
  final String actualCashCountedInput;

  final String chicken20BeginningInput;
  final String chicken20DeliveredInput;
  final String chicken20RemainingInput;

  final String chicken10BeginningInput;
  final String chicken10DeliveredInput;
  final String chicken10RemainingInput;

  final String lumpiaBeginningInput;
  final String lumpiaDeliveredInput;
  final String lumpiaRemainingInput;

  final String riceDeliveredInput;
  final String riceRemainingInput;

  const SalesRecord({
    required this.id,
    required this.businessDate,
    required this.date,
    required this.totalSales,
    required this.expectedCash,
    required this.actualCash,
    required this.difference,
    required this.startingCashInput,
    required this.actualCashCountedInput,
    required this.chicken20BeginningInput,
    required this.chicken20DeliveredInput,
    required this.chicken20RemainingInput,
    required this.chicken10BeginningInput,
    required this.chicken10DeliveredInput,
    required this.chicken10RemainingInput,
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
      'totalSales': totalSales,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'difference': difference,
      'startingCashInput': startingCashInput,
      'actualCashCountedInput': actualCashCountedInput,
      'chicken20BeginningInput': chicken20BeginningInput,
      'chicken20DeliveredInput': chicken20DeliveredInput,
      'chicken20RemainingInput': chicken20RemainingInput,
      'chicken10BeginningInput': chicken10BeginningInput,
      'chicken10DeliveredInput': chicken10DeliveredInput,
      'chicken10RemainingInput': chicken10RemainingInput,
      'lumpiaBeginningInput': lumpiaBeginningInput,
      'lumpiaDeliveredInput': lumpiaDeliveredInput,
      'lumpiaRemainingInput': lumpiaRemainingInput,
      'riceDeliveredInput': riceDeliveredInput,
      'riceRemainingInput': riceRemainingInput,
    };
  }

  factory SalesRecord.fromMap(Map<String, dynamic> map) {
    final fallbackDate = (map['date'] ?? '').toString();

    return SalesRecord(
      id: (map['id'] ?? '').toString(),
      businessDate:
          (map['businessDate'] ??
                  (fallbackDate.length >= 10
                      ? fallbackDate.substring(0, 10)
                      : ''))
              .toString(),
      date: fallbackDate,
      totalSales: map['totalSales'] ?? 0,
      expectedCash: map['expectedCash'] ?? 0,
      actualCash: map['actualCash'] ?? 0,
      difference: map['difference'] ?? 0,
      startingCashInput: (map['startingCashInput'] ?? '').toString(),
      actualCashCountedInput: (map['actualCashCountedInput'] ?? '').toString(),
      chicken20BeginningInput: (map['chicken20BeginningInput'] ?? '')
          .toString(),
      chicken20DeliveredInput: (map['chicken20DeliveredInput'] ?? '')
          .toString(),
      chicken20RemainingInput: (map['chicken20RemainingInput'] ?? '')
          .toString(),
      chicken10BeginningInput: (map['chicken10BeginningInput'] ?? '')
          .toString(),
      chicken10DeliveredInput: (map['chicken10DeliveredInput'] ?? '')
          .toString(),
      chicken10RemainingInput: (map['chicken10RemainingInput'] ?? '')
          .toString(),
      lumpiaBeginningInput: (map['lumpiaBeginningInput'] ?? '').toString(),
      lumpiaDeliveredInput: (map['lumpiaDeliveredInput'] ?? '').toString(),
      lumpiaRemainingInput: (map['lumpiaRemainingInput'] ?? '').toString(),
      riceDeliveredInput: (map['riceDeliveredInput'] ?? '').toString(),
      riceRemainingInput: (map['riceRemainingInput'] ?? '').toString(),
    );
  }
}
