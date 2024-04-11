import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/styles/spacing_styles.dart';
import 'package:smart_wallet/pages/login/forgot_password.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/signup/sign_up.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
//import 'package:smart_wallet/utils/theme/theme.dart';
import 'package:smart_wallet/common/login_signup_widgets/social_buttons.dart';
import 'package:smart_wallet/common/login_signup_widgets/form_divider.dart';

class loginHeader extends StatelessWidget {
  const loginHeader({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            height: 200,
            image: AssetImage(dark
                ? SW_Images.darkAppLogo
                : SW_Images.lightAppLogo)),
        Text(SW_Texts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: SW_Sizes.sm),
        Text(SW_Texts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}