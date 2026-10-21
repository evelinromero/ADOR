import 'package:flutter/material.dart';

const kAccent = Color(0xFFC62828); // rojo sangre
const kBackground = Color(0xFF121014);
const kSurface = Color(0xFF1E1A20);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kAccent,
    brightness: Brightness.dark,
    surface: kSurface,
    primary: const Color(0xFFEF5350),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackground,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
