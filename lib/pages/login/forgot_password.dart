import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Get.to(() => LoginPage());
          },
        ),
        title: const Text(
          'Forgot Password',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SW_Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              const Icon(
                Iconsax.lock_circle,
                size: 100,
                color: SW_Colors.primary,
              ),

              const SizedBox(height: SW_Sizes.spaceBtwSections),

              // Text
              Text(
                SW_Texts.forgotPasswordTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: SW_Sizes.spaceBtwSections),

              Text(
                SW_Texts.forgotPasswordSubTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 50),
              TextFormField(
                expands: false,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: SW_Texts.email,
                  prefixIcon: Icon(Iconsax.direct),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: SW_Sizes.spaceBtwSections),
              //Button
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: passwordReset,
                  child: const Text("Reset Password"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
