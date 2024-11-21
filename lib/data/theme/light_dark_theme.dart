import 'package:flutter/material.dart';

import 'color.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryBlue,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      buttonTheme: const ButtonThemeData(buttonColor: AppColors.primaryBlue),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),

      dialogTheme: DialogTheme(
        backgroundColor: AppColors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        elevation: 10,
        textStyle: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )));

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: AppColors.black,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.darkBlue,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      buttonTheme: const ButtonThemeData(buttonColor: AppColors.lightBlue),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),

      dialogBackgroundColor: Colors.blueGrey.shade400,
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkBlue,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        elevation: 10,
        textStyle: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )));
}
