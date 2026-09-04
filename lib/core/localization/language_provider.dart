import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ar');
  bool _isDarkMode = false;
  bool _soundEnabled = true;
  bool _timerEnabled = true;

  Locale get currentLocale => _currentLocale;
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;
  bool get timerEnabled => _timerEnabled;

  LanguageProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString('app_language') ?? 'ar';
      _currentLocale = Locale(langCode);
      _isDarkMode = prefs.getBool('app_dark_mode') ?? false;
      _soundEnabled = prefs.getBool('app_sound_enabled') ?? true;
      _timerEnabled = prefs.getBool('app_timer_enabled') ?? true;
      notifyListeners();
    } catch (_) {
      // Offline fallback
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', locale.languageCode);
    } catch (_) {}
  }

  Future<void> toggleLocale() async {
    final newLocale = _currentLocale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_dark_mode', _isDarkMode);
    } catch (_) {}
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_sound_enabled', _soundEnabled);
    } catch (_) {}
  }

  Future<void> toggleTimer() async {
    _timerEnabled = !_timerEnabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_timer_enabled', _timerEnabled);
    } catch (_) {}
  }
}
