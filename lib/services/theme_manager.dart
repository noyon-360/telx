import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static const String _themeKey = 'themeMode';

  // Save theme mode to shared preferences
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_themeKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  // Load theme mode from shared preferences
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'light'; // Default to light if no value exists
    return theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
}
