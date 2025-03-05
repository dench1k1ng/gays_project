import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  bool _isLoading = true; // Флаг загрузки

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    String? language = prefs.getString('language');

    if (theme != null) {
      _themeMode = theme == "dark" ? ThemeMode.dark : ThemeMode.light;
    }

    if (language != null) {
      _locale = Locale(language);
    }

    _isLoading = false; // Настройки загружены
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', isDark ? "light" : "dark");
    notifyListeners();
  }

  void changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    notifyListeners();
  }
}
