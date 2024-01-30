import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Sign Up'),
            centerTitle: true,
          ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],),
      ),
    );
  }
}