import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:telx/bloc/Theme%20Management/them_state.dart';
import 'package:telx/services/theme_manager.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light) {
    _loadTheme();
  }

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final themeMode = await ThemeManager.loadThemeMode();
    emit(themeMode == ThemeMode.light ? AppTheme.light : AppTheme.dark);
  }

  // Toggle the theme and save preference
  void toggleTheme() async {
    if (state == AppTheme.light) {
      emit(AppTheme.dark);
      ThemeManager.saveThemeMode(ThemeMode.dark);
    } else {
      emit(AppTheme.light);
      ThemeManager.saveThemeMode(ThemeMode.light);
    }
  }
}
