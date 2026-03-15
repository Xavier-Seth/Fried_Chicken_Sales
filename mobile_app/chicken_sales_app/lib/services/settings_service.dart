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

  static const Set<String> _supportedLocaleCodes = {'en', 'fil'};

  static int _sanitizePrice(int? value, int fallback) {
    if (value == null || value < 0) return fallback;
    return value;
  }

  static String _sanitizeLocaleCode(String? localeCode) {
    if (localeCode == null) return 'en';

    final normalized = localeCode.trim().toLowerCase();
    if (_supportedLocaleCodes.contains(normalized)) {
      return normalized;
    }

    return 'en';
  }

  static Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      chickenLargePrice: _sanitizePrice(
        prefs.getInt(_chickenLargePriceKey),
        defaultChickenLargePrice,
      ),
      chickenSmallPrice: _sanitizePrice(
        prefs.getInt(_chickenSmallPriceKey),
        defaultChickenSmallPrice,
      ),
      lumpiaPrice: _sanitizePrice(
        prefs.getInt(_lumpiaPriceKey),
        defaultLumpiaPrice,
      ),
      ricePrice: _sanitizePrice(prefs.getInt(_ricePriceKey), defaultRicePrice),
    );
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    final sanitizedSettings = AppSettings(
      chickenLargePrice: _sanitizePrice(
        settings.chickenLargePrice,
        defaultChickenLargePrice,
      ),
      chickenSmallPrice: _sanitizePrice(
        settings.chickenSmallPrice,
        defaultChickenSmallPrice,
      ),
      lumpiaPrice: _sanitizePrice(settings.lumpiaPrice, defaultLumpiaPrice),
      ricePrice: _sanitizePrice(settings.ricePrice, defaultRicePrice),
    );

    await Future.wait([
      prefs.setInt(_chickenLargePriceKey, sanitizedSettings.chickenLargePrice),
      prefs.setInt(_chickenSmallPriceKey, sanitizedSettings.chickenSmallPrice),
      prefs.setInt(_lumpiaPriceKey, sanitizedSettings.lumpiaPrice),
      prefs.setInt(_ricePriceKey, sanitizedSettings.ricePrice),
    ]);
  }

  static Future<String> getSavedLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return _sanitizeLocaleCode(prefs.getString(_localeCodeKey));
  }

  static Future<void> saveLocaleCode(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    final sanitizedLocaleCode = _sanitizeLocaleCode(localeCode);
    await prefs.setString(_localeCodeKey, sanitizedLocaleCode);
  }
}
