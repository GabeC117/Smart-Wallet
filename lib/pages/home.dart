import 'package:flutter/material.dart';
import 'package:smart_wallet/components/drawer.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/graph.dart';
import 'package:smart_wallet/pages/receipt.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

Future<String?> user() async {
  UserDatabase userDatabase = UserDatabase();
  return await userDatabase.getUsername();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = user();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade300,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Open drawer on button press
              },
            );
          },
        ),
        title: Text('Smart Wallet'),
        actions: <Widget>[],
      ),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.purple.shade100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<String?>(
                future: _usernameFuture,
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator while fetching username
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        children: <Widget>[
                          ListTile(
                            key: const Key('welcome-sw'),
                            title: Text(
                              'Welcome to your Smart Wallet! ${snapshot.data}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Add other widgets as needed
                        ],
                      );
                    }
                  }
                },
              ),
            ),
            Container(
              color: Colors.purple.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Budget()),
                      );
                    },
                    icon: Icon(Icons.attach_money, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Receipts()),
                      );
                    },
                    icon: Icon(Icons.camera_enhance, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Graphs()),
                      );
                    },
                    icon: Icon(Icons.trending_up, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.help_center_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.help_center_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
