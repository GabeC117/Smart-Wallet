import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_wallet/components/text_box.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_wallet/pages/home/home.dart';
import 'package:smart_wallet/pages/login/login.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

import '../../utils/helpers/helper_functions.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late Future<String?> _usernameFuture;
  late Future<String?> _emailFuture;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  Uint8List? _image;
  String? _profilePictureUrl; // Added to store profile picture URL
  bool _isPNG = false;

  @override
  void initState() {
    super.initState();
    _usernameFuture = UserDatabase().getUsername();
    _emailFuture = UserDatabase().getEmail();
    _fetchProfilePictureUrl(); // Retrieve profile picture URL when the page initializes
  }

  Future<void> _removeAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      // Sign out the user after account removal
      await FirebaseAuth.instance.signOut();
      Get.to(() => LoginPage()); // Close the current screen
      // Optionally, navigate to another screen or show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your account has been successfully removed.'),
        ),
      );
    } catch (e) {
      // Handle account removal errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while removing your account.'),
        ),
      );
    }
  }

  Future<void> editField(String field) async {
    if (field == 'username') {
      await UserDatabase().updateUsername(_usernameController.text);
      setState(() {
        _usernameFuture = UserDatabase().getUsername();
      });
    } else if (field == 'email') {
      await UserDatabase().updateEmail(_emailController.text);
      setState(() {
        _emailFuture = UserDatabase().getEmail();
      });
    }
  }

  Future<void> _fetchProfilePictureUrl() async {
    try {
      // Retrieve the profile picture URL from Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _profilePictureUrl = userSnapshot.get('profilePicture');
        });
      }
    } catch (error) {
      print('Error fetching profile picture URL: $error');
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No images selected!');
    return null;
  }

  Future<void> selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      // Upload image to Firebase Storage and update user profile
      uploadImageToFirebase(img);
    }
  }

  Future<void> uploadImageToFirebase(Uint8List image) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${currentUser.uid}');

      UploadTask uploadTask = storageReference.putData(image);

      String imageUrl = await (await uploadTask).ref.getDownloadURL();

      // Update user profile with the download URL
      await UserDatabase().updateProfilePicture(imageUrl);
      setState(() {
        _profilePictureUrl =
            imageUrl; // Update profile picture URL in the widget state
      });
    } catch (e) {
      print('Failed to upload image to Firebase Storage: $e');
    }
  }

  // Widget build method remains unchanged
  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<String?>(
                future: _usernameFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<String?> usernameSnapshot) {
                  if (usernameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    if (usernameSnapshot.hasError) {
                      return Text('Error: ${usernameSnapshot.error}');
                    } else {
                      return FutureBuilder<String?>(
                        future: _emailFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> emailSnapshot) {
                          if (emailSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            if (emailSnapshot.hasError) {
                              return Text('Error: ${emailSnapshot.error}');
                            } else {
                              return ListView(
                                children: <Widget>[
                                  const SizedBox(height: 50),
                                  // Profile picture
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 65,
                                        backgroundColor: Colors.blue.shade900,
                                        backgroundImage: _profilePictureUrl !=
                                                null
                                            ? NetworkImage(_profilePictureUrl!)
                                            : NetworkImage(
                                                'https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg'),
                                      ),
                                      Positioned(
                                        bottom: -10,
                                        right: 110,
                                        child: IconButton(
                                          onPressed: selectImage,
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),
                                  // Email
                                  Text(
                                    '${usernameSnapshot.data}',
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 20),
                                  // Details
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Text('My Details',
                                        style: TextStyle(
                                            color: Colors.grey.shade500)),
                                  ),
                                  // Username
                                  MyTextBox(
                                    text: '${usernameSnapshot.data}',
                                    sectionName: 'Username',
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edit Username'),
                                          content: TextFormField(
                                            controller: _usernameController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new username',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                editField('username');
                                                Navigator.pop(context);
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  // Email
                                  MyTextBox(
                                    text: currentUser.email!,
                                    sectionName: 'Email',
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edit Email'),
                                          content: TextFormField(
                                            controller: _emailController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter new email',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                editField('email');
                                                Navigator.pop(context);
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      );
                    }
                  }
                },
              ),
            ),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: currentUser.email!);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Password Reset Email Sent'),
                          content: const Text(
                              'Please check your email to reset your password.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Failed to send password reset email. Please try again later.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    print('Failed to send password reset email: $e');
                  }
                },
                child: const Text('Change Password'),
              ),
            ),
            const SizedBox(height: SW_Sizes.defaultSpace / 2),
            SizedBox(
                width: 160,
                child: OutlinedButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Account Deletion'),
                              content: Text(
                                  'Are you sure you want to delete your account? This action is irreversible.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                      context), // Close dialog without deleting
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Close dialog after confirmation
                                    _removeAccount(
                                        context); // Call function to delete account
                                  },
                                  child: Text('Delete',
                                      style: TextStyle(
                                          color: Colors
                                              .red)), // Highlight delete option
                                ),
                              ],
                            );
                          },
                        ),
                    child: Text(
                      'Remove Account',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))),
            const SizedBox(height: SW_Sizes.defaultSpace),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
