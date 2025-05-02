import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.amber,
    colorScheme: const ColorScheme.light(
      primary: Colors.amber,
      secondary: Colors.amberAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.amber[800],
    colorScheme: ColorScheme.dark(
      primary: Colors.amber[800]!,
      secondary: Colors.amber[700]!,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.amber[800],
      foregroundColor: Colors.white,
    ),
  );
}