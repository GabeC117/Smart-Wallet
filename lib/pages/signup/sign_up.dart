import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/login_signup_widgets/form_divider.dart';
import 'package:smart_wallet/common/login_signup_widgets/social_buttons.dart';
import 'package:smart_wallet/pages/signup/widgets/signup_form.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';

import '../../utils/helpers/helper_functions.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    //final dark = SW_Helpers.isDarkMode(context);

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SW_Sizes.defaultSpace),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Title
            Text(
              SW_Texts.signupTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: SW_Sizes.spaceBtwSections),

            // Form
            const signUpForm(),
            const SizedBox(height: SW_Sizes.spaceBtwSections),

            // Divider
            const formDivider(dividerText: SW_Texts.orSignUpwith),

            const SizedBox(height: SW_Sizes.spaceBtwSections / 2),

            // Icons
            const socialButtons(),


          ]),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:smart_wallet/main.dart';
// import 'package:smart_wallet/pages/login/login.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _usernameController = TextEditingController();

//   Future<void> _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set({
//           'username': _usernameController.text.trim(),
//         });

//         // Sign up successful
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Sign up successful')));
//         // navigate the user to another screen
//         Navigator.pop(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       } on FirebaseAuthException catch (e) {
//         // Handle errors
//         var message = 'An error occurred. Please try again later.';
//         if (e.code == 'weak-password') {
//           message = 'The password provided is too weak.';
//         } else if (e.code == 'email-already-in-use') {
//           message = 'An account already exists for that email.';
//         }
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(message)));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('Sign Up'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(labelText: 'Username'),
//                   obscureText: false,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your username';
//                     }
//                     if (value.length < 6) {
//                       return 'username must be at least 6 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _signUp,
//                   child: Text('Sign Up'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }