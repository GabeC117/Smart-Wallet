import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_wallet/components/my_button.dart';
import 'package:smart_wallet/components/square_tile.dart';
import 'package:smart_wallet/components/my_textfield.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:smart_wallet/pages/sign_up.dart';
import 'package:smart_wallet/pages/forgot_password.dart';
import 'package:smart_wallet/utils/theme/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

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
          .showSnackBar(SnackBar(content: Text('Sign in successful')));
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
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              //logo
              FaIcon(FontAwesomeIcons.wallet,
                  size: 100, color: Color(0xFF204683)),

              const SizedBox(height: 30.0),

              //Welcome to your Smart Wallet
              Text(
                "Welcome to your Smart Wallet!",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 30.0),

              // Email / Username texfield
              MyTextField(
                  testKey: const Key('email-field'),
                  controller: _usernameController,
                  hintText: 'Username/Email',
                  obscureText: false),

              const SizedBox(height: 10.0),

              // Password Textfield
              MyTextField(
                  testKey: const Key('password-field'),
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(height: 5.0),

              // Remember me & Forgot Password
              // Connect to Firebase
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: rememberMeValue,
                          onChanged: (newValue) {
                            setState(() {
                              rememberMeValue = newValue ?? false;
                            });
                          },
                          activeColor: Color(0xFF204683),
                        ),
                        Text(
                          'Remember Me',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          key: const Key('forgot-pass'),
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15.0),

              // Sign in button
              MyButton(
                testKey: const Key('login-btt'),
                onTap: _login,
              ),

              const SizedBox(height: 30.0),

              // Or continue with ...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[400]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or login using',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[400]),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30.0),

              // Google + apple sign in buttons
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                SquareTile(icon: FontAwesomeIcons.google),
                const SizedBox(width: 30.0),
                SquareTile(icon: FontAwesomeIcons.apple)
              ]),

              const SizedBox(height: 20.0),

              // Now a member? Sign Up Now

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text('Sign Up Now!',
                          style: Theme.of(context).textTheme.bodyLarge))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
