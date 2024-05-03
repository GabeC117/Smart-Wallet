import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/common/profile_picture/profile_picture.dart';
import 'package:smart_wallet/components/list_tile.dart';
import 'package:smart_wallet/pages/account/account.dart';
import 'package:smart_wallet/pages/budget.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart'; // Import the helper function to check dark mode

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, this.profilePictureUrl}) : super(key: key);

  final String? profilePictureUrl;

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
    final currentUser = FirebaseAuth.instance.currentUser!;
    final dark = SW_Helpers.isDarkMode(context); // Check if dark mode is enabled

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: SW_Colors.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: <Widget>[
              // Header with profile picture
              const ProfilePicture(),
              const SizedBox(height: SW_Sizes.spaceBtwSections,),
              // Home
              MyListTile(
                icon: Icons.home,
                text: 'HOME',
                onTap: () => Navigator.pop(context),
              ),

              // Profile
              MyListTile(
                icon: Icons.person,
                text: 'ACCOUNT',
                onTap: () => Get.to(() => Account()),
              ),

              // Budget
              MyListTile(
                icon: Iconsax.money,
                text: 'BUDGET',
                onTap: () => Get.to(() => Budget()),
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
      ),
    );
  }
}

