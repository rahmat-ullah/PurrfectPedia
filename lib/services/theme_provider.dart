import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purrfect_pedia/models/theme_preference.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference'; // Corrected variable name
  ThemeModePreference _currentPreference = ThemeModePreference.system;

  ThemeModePreference get currentPreference => _currentPreference;

  ThemeMode get themeMode {
    if (_currentPreference == ThemeModePreference.light) {
      return ThemeMode.light;
    } else if (_currentPreference == ThemeModePreference.dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  ThemeProvider() {
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final preferenceString = prefs.getString(_themePreferenceKey);
    if (preferenceString != null) {
      _currentPreference = ThemeModePreference.values.firstWhere(
        (e) => e.toString() == preferenceString,
        orElse: () => ThemeModePreference.system,
      );
    }
    // Notifying listeners here might be premature if the app hasn't fully loaded.
    // However, it's standard practice to notify after loading initial state.
    notifyListeners();
  }

  Future<void> setThemePreference(ThemeModePreference preference) async {
    _currentPreference = preference;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, preference.toString());
    notifyListeners();
  }
}
