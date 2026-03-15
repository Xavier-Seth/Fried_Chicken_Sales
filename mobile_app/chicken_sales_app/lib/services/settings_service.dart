import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final int chickenLargePrice;
  final int chickenSmallPrice;
  final int lumpiaPrice;
  final int ricePrice;

  const AppSettings({
    required this.chickenLargePrice,
    required this.chickenSmallPrice,
    required this.lumpiaPrice,
    required this.ricePrice,
  });

  AppSettings copyWith({
    int? chickenLargePrice,
    int? chickenSmallPrice,
    int? lumpiaPrice,
    int? ricePrice,
  }) {
    return AppSettings(
      chickenLargePrice: chickenLargePrice ?? this.chickenLargePrice,
      chickenSmallPrice: chickenSmallPrice ?? this.chickenSmallPrice,
      lumpiaPrice: lumpiaPrice ?? this.lumpiaPrice,
      ricePrice: ricePrice ?? this.ricePrice,
    );
  }
}

class SettingsService {
  static const int defaultChickenLargePrice = 20;
  static const int defaultChickenSmallPrice = 12;
  static const int defaultLumpiaPrice = 5;
  static const int defaultRicePrice = 10;

  static const String _chickenLargePriceKey = 'price_chicken_large';
  static const String _chickenSmallPriceKey = 'price_chicken_small';
  static const String _lumpiaPriceKey = 'price_lumpia';
  static const String _ricePriceKey = 'price_rice';
  static const String _localeCodeKey = 'app_locale_code';

  static Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      chickenLargePrice:
          prefs.getInt(_chickenLargePriceKey) ?? defaultChickenLargePrice,
      chickenSmallPrice:
          prefs.getInt(_chickenSmallPriceKey) ?? defaultChickenSmallPrice,
      lumpiaPrice: prefs.getInt(_lumpiaPriceKey) ?? defaultLumpiaPrice,
      ricePrice: prefs.getInt(_ricePriceKey) ?? defaultRicePrice,
    );
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_chickenLargePriceKey, settings.chickenLargePrice);
    await prefs.setInt(_chickenSmallPriceKey, settings.chickenSmallPrice);
    await prefs.setInt(_lumpiaPriceKey, settings.lumpiaPrice);
    await prefs.setInt(_ricePriceKey, settings.ricePrice);
  }

  static Future<String> getSavedLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeCodeKey) ?? 'en';
  }

  static Future<void> saveLocaleCode(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, localeCode);
  }
}
