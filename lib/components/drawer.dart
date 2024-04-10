import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/login.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  void logOut(BuildContext context) {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: Colors.blue.shade900,
        child: Column(
          children: <Widget>[
            // Header
            DrawerHeader(
              child: Icon(Icons.person, color: Colors.blue.shade100, size: 70),
            ),
            // Home
            MyListTile(
              icon: Icons.home,
              text: 'HOME',
              onTap: () => Navigator.pop(context),
            ),

            //Profile
            MyListTile(
              icon: Icons.person,
              text: 'ACCOUNT',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),
                );
              },
            ),

            // Budget
            MyListTile(
              icon: Icons.money,
              text: 'BUDGET',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Budget()),
                );
              },
            ),

            // Log Out
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: MyListTile(
                icon: Icons.logout,
                text: 'LOG OUT',
                onTap: () => logOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
