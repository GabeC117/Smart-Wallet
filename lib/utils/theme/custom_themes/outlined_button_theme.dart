import 'package:flutter/material.dart';

class SW_OutlinedButtonTheme {
  SW_OutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => Colors.black.withOpacity(0.1)),
      side: MaterialStateProperty.resolveWith(
          (states) => BorderSide(color: Colors.black)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => Colors.white.withOpacity(0.1)),
      side: MaterialStateProperty.resolveWith(
          (states) => BorderSide(color: Colors.white)),
    ),
  );
}
