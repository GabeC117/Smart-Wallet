import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/login_signup_widgets/form_divider.dart';
import 'package:smart_wallet/common/login_signup_widgets/social_buttons.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/home/home.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';

class signUpForm extends StatefulWidget {
  const signUpForm({Key? key}) : super(key: key);

  @override
  State<signUpForm> createState() => _signUpFormState();
}

class _signUpFormState extends State<signUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool termsAndConditions = false;
  bool _obscureText = true;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match.'),
      ));
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': _usernameController.text.trim(),
      });

      // Sign up successful
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up successful')));
      // navigate the user to another screen
      Get.to(() => HomePage());
    } on FirebaseAuthException catch (e) {
      // Handle errors
      var message = 'An error occurred. Please try again later.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Form(
      child: Column(
        children: [
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: SW_Texts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: SW_Sizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: SW_Texts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: SW_Sizes.spaceBtwInputFields),

          // Username
          TextFormField(
            controller: _usernameController,
            expands: false,
            decoration: const InputDecoration(
              labelText: SW_Texts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              if (value.length < 6) {
                return 'username must be at least 6 characters long';
              }
              return null;
            },
          ),

          const SizedBox(height: SW_Sizes.spaceBtwInputFields),

          // Email
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

          const SizedBox(height: SW_Sizes.spaceBtwInputFields),

          // Phone Number
          // TextFormField(
          //         expands: false,
          //         decoration: const InputDecoration(
          //             labelText: SW_Texts.phoneNumber,
          //             prefixIcon: Icon(Iconsax.call),
          //             ),
          //       ),

          // const SizedBox(height: SW_Sizes.spaceBtwInputFields),

          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              labelText: SW_Texts.password,
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              if (value.length < 6) {
                return 'username must be at least 6 characters long';
              }
              return null;
            },
          ),

          const SizedBox(height: SW_Sizes.spaceBtwInputFields),

          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              labelText: SW_Texts.confirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          const SizedBox(height: SW_Sizes.spaceBtwSections),

          // Terms & Conditions Checkbox
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: termsAndConditions,
                  onChanged: (newValue) {
                    setState(() {
                      termsAndConditions = newValue ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: SW_Sizes.spaceBtwItems),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '${SW_Texts.iAgreeTo} ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: SW_Texts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark
                                  ? SW_Colors.textWhite
                                  : SW_Colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark
                                  ? SW_Colors.textWhite
                                  : SW_Colors.primary,
                            )),
                    TextSpan(
                        text: ' ${SW_Texts.and} ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: SW_Texts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark
                                  ? SW_Colors.textWhite
                                  : SW_Colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark
                                  ? SW_Colors.textWhite
                                  : SW_Colors.primary,
                            )),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: SW_Sizes.spaceBtwSections),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signUp,
              child: const Text(SW_Texts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
