import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sales_record.dart';

class SalesStorage {
  static const String key = 'sales_history';

  static Future<void> saveOrUpdateRecord(SalesRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];

    final records = existing
        .map((item) => SalesRecord.fromMap(jsonDecode(item)))
        .toList();

    final index = records.indexWhere(
      (r) => r.businessDate == record.businessDate,
    );

    if (index >= 0) {
      records[index] = record;
    } else {
      records.add(record);
    }

    final encoded = records.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<List<SalesRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];

    return existing
        .map((item) => SalesRecord.fromMap(jsonDecode(item)))
        .toList();
  }

  static Future<SalesRecord?> getRecordByBusinessDate(
    String businessDate,
  ) async {
    final records = await getRecords();

    try {
      return records.firstWhere(
        (record) => record.businessDate == businessDate,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];

    final updated = existing.where((item) {
      final record = SalesRecord.fromMap(jsonDecode(item));
      return record.id != id;
    }).toList();

    await prefs.setStringList(key, updated);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
