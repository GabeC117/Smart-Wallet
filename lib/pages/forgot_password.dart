import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Forgot Password',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please provide your email address, and we will send you a link to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade900),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 50),
          //Button
          MaterialButton(
            onPressed: passwordReset,
            child:
                Text("Reset Password", style: TextStyle(color: Colors.white)),
            color: Colors.blue.shade900,
          )
        ],
      ),
    );
  }
}
// class ForgotPassword extends StatefulWidget {
//   @override
//   _ForgotPasswordState createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _newPasswordController = TextEditingController();
//   TextEditingController _confirmPasswordController = TextEditingController();

//   Future passwordReset() async {
//     await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forgot Password'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _newPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'New Password'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Confirm New Password'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (_newPasswordController.text == _confirmPasswordController.text) {
//                   // Add logic here to handle the password update in your backend
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Password Update Successful'),
//                       content: Text('Your password has been updated successfully.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('OK'),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   // Error handling if the passwords do not match
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Error'),
//                       content: Text('The passwords do not match. Please try again.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('OK'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//               child: Text('Update Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
