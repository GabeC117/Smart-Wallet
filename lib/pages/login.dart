import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/styles/spacing_styles.dart';
import 'package:smart_wallet/pages/forgot_password.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/sign_up.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
//import 'package:smart_wallet/utils/theme/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMeValue = false;

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Sign up successful
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign in successful')));
      // Optionally, navigate the user to another screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      var message = 'An error occurred. Please try again later.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Scaffold(
      // body: SafeArea(
      body: SingleChildScrollView(
        child: Padding(
          padding: SW_SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo, Title & Sub-Title
              Column(
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
              ),

              // Form
              Form(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: SW_Sizes.spaceBtwSections),
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: SW_Texts.email,
                      ),
                    ),
                    const SizedBox(height: SW_Sizes.spaceBtwItems / 2),
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: SW_Texts.password,
                        suffixIcon: Icon(
                          Iconsax.eye_slash,
                        ),
                      ),
                    ),
                    const SizedBox(height: SW_Sizes.spaceBtwInputFields / 2),

                    // Remember me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Remember me
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value) {}),
                            const Text(SW_Texts.rememberMe),
                          ],
                        ),
                        const SizedBox(width: SW_Sizes.spaceBtwInputFields),

                        // Forgot Password
                        TextButton(
                            onPressed: () {
                              Get.to(const ForgotPassword());
                            },
                            child: Text(
                              SW_Texts.forgotPassword,
                              style: Theme.of(context).textTheme.labelLarge,
                            ))
                      ],
                    ),
                    const SizedBox(height: SW_Sizes.spaceBtwSections / 2),

                    // Sign in Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text(SW_Texts.signIn),
                        // style: ButtonStyle(
                        //   backgroundColor: MaterialStateProperty.all<Color>(
                        //       SW_Colors.primary),
                        // ),
                        style: Theme.of(context).elevatedButtonTheme.style,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: _login,
                    //   child: Container(
                    //       padding: const EdgeInsets.all(25),
                    //       margin: const EdgeInsets.symmetric(horizontal: 25),
                    //       decoration: BoxDecoration(
                    //           color: Color(0xFF065A82),
                    //           borderRadius: BorderRadius.circular(8)),
                    //       child: const Center(
                    //         child: Text(
                    //           'Log In',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16,
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(height: SW_Sizes.spaceBtwItems),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () {
                            Get.to(SignUp());
                          },
                          child: const Text(SW_Texts.createAccount)),
                    ),
                    const SizedBox(height: SW_Sizes.spaceBtwItems),

                    // Divider
                    Row(
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
                          SW_Texts.orSignInwith,
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
                    ),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: SW_Colors.grey),
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                                width: SW_Sizes.iconMd,
                                height: SW_Sizes.iconMd,
                                image: AssetImage(SW_Images.google)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
