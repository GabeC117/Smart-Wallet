import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:smart_wallet/pages/sign_up.dart';
import 'package:smart_wallet/pages/forgot_password.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Email (Username is user)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password (Password is password)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Perform login logic here (e.g., check username and password)
                // For simplicity, a basic check is performed here
                if (_usernameController.text == 'user' &&
                    _passwordController.text == 'password') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  // Show an error message or handle unsuccessful login
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Login Failed'),
                      content: Text('Invalid username or password.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUp()));
              }, 
              child: Text('Sign Up'),
              ),

               ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
                }, 
                child: Text('Forgot Password'),
              ),
          ],
        ),
      ),
    );
  }
}
