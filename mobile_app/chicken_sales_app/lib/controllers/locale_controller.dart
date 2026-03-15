import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._(this._locale);

  static const List<Locale> supportedLocales = [Locale('en'), Locale('fil')];

  Locale _locale;

  Locale get locale => _locale;

  static Future<LocaleController> create() async {
    final savedCode = await SettingsService.getSavedLocaleCode();
    return LocaleController._(_toSupportedLocale(savedCode));
  }

  Future<void> setLocale(Locale locale) async {
    final nextLocale = _toSupportedLocale(locale.languageCode);

    if (_locale.languageCode == nextLocale.languageCode) {
      return;
    }

    _locale = nextLocale;
    await SettingsService.saveLocaleCode(nextLocale.languageCode);
    notifyListeners();
  }

  static Locale _toSupportedLocale(String code) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == code) {
        return locale;
      }
    }
    return const Locale('en');
  }
}
