import 'package:flutter/material.dart';

// Tema creat amb fromSeed

class AppTheme {
  static const Color brandColor = Color(0xff2D5027);

  // Constructor de ColorScheme amb nom (fromSeed)
  static final ColorScheme lightScheme =
      ColorScheme.fromSeed(
        seedColor: brandColor,
        brightness: Brightness.light,
      ).copyWith(
        // Per si volguerem afegir modificacions
        //  secondary: Color(0xff4CAF50), // verd més clar
        // onSecondary: Colors.white,
      ); // Modificacions

  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: brandColor,
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightScheme.secondary,
      foregroundColor: lightScheme.onSecondary,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(elevation: 4, clipBehavior: Clip.antiAlias),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkScheme.secondary,
      foregroundColor: darkScheme.onSecondary,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(elevation: 4, clipBehavior: Clip.antiAlias),
  );
}
