import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Colores principales
  static const Color primary = Color(0xFF34D1A1); // verde menta
  static const Color secondary = Color(0xFF1E293B); // color de texto principal
  static const Color accent = Color(0xFFFFC107); // amarillo/amber
  static const Color background = Color(0xFFF4F4F4); // fondo claro usado antes

  // color semántico para texto (útil si quieres separarlo de "secondary")
  static const Color textColor = secondary;

  // 🖋 Tipografías/estilos reutilizables
  static final TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static final TextStyle body = const TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static final TextStyle caption = const TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  // 🎯 Border radius estándar
  static final BorderRadius borderRadius = BorderRadius.circular(16);

  // 🎯 ThemeData para toda la app
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primary),
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
    ),
    textTheme: TextTheme(
      titleLarge: title,
      bodyMedium: body,
      bodySmall: caption,
    ),

  );
}
