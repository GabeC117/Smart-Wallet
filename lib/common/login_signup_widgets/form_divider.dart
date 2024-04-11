import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
//import 'package:smart_wallet/utils/theme/theme.dart';
import 'package:smart_wallet/common/login_signup_widgets/social_buttons.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';


class formDivider extends StatelessWidget {
  final String dividerText;

  const formDivider({
    Key? key,
    required this.dividerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? SW_Colors.darkGrey : SW_Colors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          dividerText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? SW_Colors.darkGrey : SW_Colors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}