import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/home.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  void logOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue.shade900,
      child: Column(
        //padding: EdgeInsets.zero,
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
    );
  }
}
