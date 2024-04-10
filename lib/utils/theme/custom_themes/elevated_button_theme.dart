import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/colors.dart';

// Light & Dark Elevated Button Themes
class SWelevatedButtonTheme {
  SWelevatedButtonTheme._();

  // Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        // foregroundColor: Colors.white,
        // backgroundColor: Colors.blue,
        // disabledForegroundColor: Colors.grey,
        // disabledBackgroundColor: Colors.grey,
        onPrimary: Colors.white,
        primary: SW_Colors.primary,
        onSurface: Colors.grey,
        shadowColor: Colors.transparent,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  );

  //Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        onPrimary: Colors.white,
        primary: SW_Colors.primary,
        onSurface: Colors.grey,
        shadowColor: Colors.transparent,
        side: const BorderSide(color: SW_Colors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  );
}

// Testing

  // final darkElevatedButtonTheme = ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //     elevation: MaterialStateProperty.all<double>(0),
  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //     backgroundColor: MaterialStateProperty.all<Color>(SW_Colors.primary),
  //     overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
  //     side: MaterialStateProperty.all<BorderSide>(
  //         BorderSide(color: SW_Colors.primary)),
  //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
  //         EdgeInsets.symmetric(vertical: 18)),
  //     textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
  //         fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
  //     shape: MaterialStateProperty.all<OutlinedBorder>(
  //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  //   ).merge(
  //     ElevatedButton.styleFrom(
  //       textStyle: TextStyle(
  //         fontSize: 16,
  //         color: Colors.white,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       padding: EdgeInsets.symmetric(vertical: 18),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //     ),
  //   ),
  // );
  //}
