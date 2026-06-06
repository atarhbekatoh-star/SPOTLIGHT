import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Colors
  static const Color _darkBackground = Color(0xFF060914);
  static const Color _darkCardColor = Color(0xFF11162D);
  static const Color _darkTextColor = Colors.white;
  static const Color _darkSubTextColor = Colors.grey;

  // Light Theme Colors
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightCardColor = Colors.white;
  static const Color _lightTextColor = Color(0xFF1E293B);
  static const Color _lightSubTextColor = Color(0xFF64748B);

  // Common Accent Colors
  static const Color primaryAccent = Color(0xFFBB86FC);
  static const Color secondaryAccent = Colors.blueAccent;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    primaryColor: primaryAccent,
    cardColor: _darkCardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _darkTextColor),
      bodyMedium: TextStyle(color: _darkTextColor),
      titleLarge: TextStyle(color: _darkTextColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
        color: _darkTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(color: _darkSubTextColor),
    ),
    iconTheme: const IconThemeData(color: _darkTextColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkBackground,
      selectedItemColor: primaryAccent,
      unselectedItemColor: _darkSubTextColor,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackground,
    primaryColor: primaryAccent,
    cardColor: _lightCardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _lightTextColor),
      bodyMedium: TextStyle(color: _lightTextColor),
      titleLarge: TextStyle(
        color: _lightTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: _lightTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(color: _lightSubTextColor),
    ),
    iconTheme: const IconThemeData(color: _lightTextColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightCardColor,
      selectedItemColor: primaryAccent,
      unselectedItemColor: _lightSubTextColor,
      elevation: 8,
    ),
  );
}
