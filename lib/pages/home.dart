import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade300,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title: const Text('Smart Wallet'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text(
              'Test:Back to Sign in',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.purple.shade100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Welcome to your Smart Wallet! ${FirebaseAuth.instance.currentUser?.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Budget'),
                        )
                      ]),
                ],
              ),
            ),
            Container(
              color: Colors.purple.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_money, color: Colors.white)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_enhance, color: Colors.white)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.trending_up, color: Colors.white)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.help_center_outlined)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.help_center_outlined)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
