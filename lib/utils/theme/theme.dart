import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/theme/custom_themes/chip_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/text_field_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/text_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/check_box_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:smart_wallet/utils/theme/custom_themes/outlined_button_theme.dart';

class SW_AppTheme {
  SW_AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // fontFamily : choose a font
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: SWtextTheme.lightTextTheme,
    elevatedButtonTheme: SWelevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: SW_AppBarTheme.lightAppBarTheme,
    bottomSheetTheme: SW_BottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: SW_CheckBoxTheme.lightCheckboxTheme,
    chipTheme: SW_ChipTheme.lightChipTheme,
    outlinedButtonTheme: SW_OutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: SW_TextFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // fontFamily : choose a font
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: SWtextTheme.darkTextTheme,
    elevatedButtonTheme: SWelevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: SW_AppBarTheme.darkAppBarTheme,
    bottomSheetTheme: SW_BottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: SW_CheckBoxTheme.darkCheckboxTheme,
    chipTheme: SW_ChipTheme.darkChipTheme,
    outlinedButtonTheme: SW_OutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: SW_TextFieldTheme.darkInputDecorationTheme,
  );
}
