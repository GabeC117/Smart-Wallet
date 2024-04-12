import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/pages/login/forgot_password.dart';
import 'package:smart_wallet/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/signup/sign_up.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
//import 'package:smart_wallet/utils/theme/theme.dart';

class loginForm extends StatefulWidget {
  const loginForm({ Key? key }) : super(key: key);

  @override
  State<loginForm> createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  bool rememberMeValue = false;
  bool _obscureText = true;
  

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Sign up successful
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign in successful')));
      // Handle "remember me" functionality
      if (rememberMeValue) {}

      // Optionally, navigate the user to another screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
      Get.to(() => HomePage());
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
    return Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: SW_Sizes.spaceBtwSections),
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: SW_Texts.email,
                        ),
                      ),

                      const SizedBox(height: SW_Sizes.spaceBtwItems / 2),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.password_check),
                          labelText: SW_Texts.password,
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText ? Iconsax.eye_slash : Iconsax.eye),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
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
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: rememberMeValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      rememberMeValue = newValue ?? false;
                                    });
                                  },
                                ),
                              ),
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
                        ),
                      ),
                      const SizedBox(height: SW_Sizes.spaceBtwItems),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () => Get.to(() => SignUp()),
                            child: Text(SW_Texts.createAccount,
                                style: Theme.of(context).textTheme.bodyMedium)),
                      ),
                    ],
                  ),
                ),
              );
  }
}