import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

class SW_SpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: SW_Sizes.appBarHeight,
    left: SW_Sizes.defaultSpace,
    bottom: SW_Sizes.defaultSpace,
    right: SW_Sizes.defaultSpace,
  );
}
