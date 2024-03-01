import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/components/text_box.dart';

class Account extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Account'),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          const SizedBox(height: 50),
          // Profile picture
          Icon(Icons.person, color: Colors.blue.shade900, size: 80),

          const SizedBox(height: 20),
          // Email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
          // Details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text('My Details',
                style: TextStyle(color: Colors.grey.shade500)),
          ),
          // Username
          MyTextBox(
            text: currentUser?.displayName ?? 'No username available',
            sectionName: 'Username',
            onPressed: () => editField('username'),
          ),
        ]));
  }
}



/*
use following code on a button to get to this page.


onPressed: () {
  Navigator.push(context,
  MaterialPageRoute(builder: (context) => Account()));
}, 

*/