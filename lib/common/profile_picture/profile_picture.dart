import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_wallet/utils/constants/colors.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    pickedImage = _cachedProfileImage;
    if (pickedImage == null) {
      getProfilePicture();
    }
  }

  static Uint8List? _cachedProfileImage;

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_images/${currentUser.uid}');
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() {
      pickedImage = imageBytes;
      _cachedProfileImage = imageBytes;
    });
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_images/${currentUser.uid}');

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() {
        pickedImage = imageBytes;
        _cachedProfileImage = imageBytes;
      });
    } catch (e) {
      print('Profile picture could not be found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: SW_Colors.primary,
            shape: BoxShape.circle,
            image: pickedImage != null
                ? DecorationImage(
                    image: MemoryImage(pickedImage!),
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          child: pickedImage == null
              ? const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 50,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: -10,
          right: 110,
          child: IconButton(
            onPressed: () {
              selectImage();
            },
            icon: const Icon(
              Icons.add_a_photo,
              color: SW_Colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
