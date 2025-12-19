import 'package:flutter/material.dart';

class AppTheme {
  // Colors based on reference images
  static const Color primaryGreen = Color(0xFF6B8E23); // Olive green
  static const Color darkBrown = Color(0xFF3E2723);
  static const Color lightCream = Color(0xFFF5F5DC);
  static const Color accentGreen = Color(0xFF8FBC8F);
  static const Color backgroundColor = Color(0xFFFAF9F6);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: accentGreen,
      surface: lightCream,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBrown,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCream,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: lightCream,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkBrown,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkBrown,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkBrown,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkBrown,
      ),
    ),
  );
}
