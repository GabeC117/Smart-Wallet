import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/styles/spacing_styles.dart';
import 'package:smart_wallet/pages/login/forgot_password.dart';
import 'package:smart_wallet/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/login/widgets/login_form.dart';
import 'package:smart_wallet/pages/signup/sign_up.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
//import 'package:smart_wallet/utils/theme/theme.dart';
import 'package:smart_wallet/common/login_signup_widgets/social_buttons.dart';
import 'package:smart_wallet/common/login_signup_widgets/form_divider.dart';

import 'widgets/login_header.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    //final dark = SW_Helpers.isDarkMode(context);

    return Scaffold(
      // body: SafeArea(
      body: SingleChildScrollView(
        child: Padding(
          padding: SW_SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Logo, Title & Sub-Title
              loginHeader(),

              // Form
              loginForm(),

              // Divider
              formDivider(dividerText: SW_Texts.orSignInwith),

              SizedBox(height: SW_Sizes.spaceBtwItems),

              // Footer. Sign in with Google or Apple
              socialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
