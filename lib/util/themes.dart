import 'package:flutter/material.dart';

class Themes {
  static const Color backgroundColor = Color(0xFFEFF3F8);
}

const MaterialColor primarySwatch = MaterialColor(0xFF93003C, <int, Color>{
  50: Color(0xFFF5E1E8),
  100: Color(0xFFE3B2C1),
  200: Color(0xFFD38099),
  300: Color(0xFFC14D71),
  400: Color(0xFFB22656),
  500: Color(0xFF93003C),
  600: Color(0xFF890036),
  700: Color(0xFF7A002E),
  800: Color(0xFF690026),
  900: Color(0xFF4D001C),
});

final ThemeData appTheme = ThemeData(
  // Set the app's primary color theme
  primarySwatch: primarySwatch,
  appBarTheme: const AppBarTheme(
    color: primarySwatch, // Set the app bar color
  ),
);
