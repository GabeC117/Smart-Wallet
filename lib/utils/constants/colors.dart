import 'package:flutter/material.dart';

class SW_Colors {
  SW_Colors._();

  // App colors
  static const Color primary = Color(0xFF4b68FF);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.737, -0.787),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad9c4),
      Color(0xfffad0c4),
    ],
  );

  // button Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFf6f6f6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFf3f5ff);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFf6f6f6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xFFc4c4c4);

  // Border Colors
  static const Color borderPrimary = Color(0xFFd9d9d9);
  static const Color borderSecondary = Color(0xFFe6e6e6);

  // Error and Validation Colors
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Color(0xFF1976d2);

  // Natural Shades
  // Error and Validation Colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4f4f4f);
  static const Color darkGrey = Color(0xFF808080);
  static const Color grey = Color(0xFF939393);
}
