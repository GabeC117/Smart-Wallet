import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/pages/account/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/home/home.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:smart_wallet/utils/constants/colors.dart';

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
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: SW_Colors.primary,
        child: Column(
          children: <Widget>[
            // Header
            const DrawerHeader(
              child: Icon(Icons.person, size: 70),
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
              onTap: () => Get.to(() => Account(),),
            ),

            // Budget
            MyListTile(
              icon: Iconsax.money,
              text: 'BUDGET',
              onTap: () => Get.to(() => Budget(),),
            ),

            // Log Out
            const Spacer(),
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
