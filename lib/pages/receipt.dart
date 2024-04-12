import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

class PicturePage extends StatefulWidget {
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  late List<String> _imageUrls = [];

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    try {
      // Get reference to the storage bucket
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the folder where your images are stored
      Reference imagesRef = storage
          .ref()
          .child('images/${FirebaseAuth.instance.currentUser?.uid}');

      // Get the list of files in the folder
      ListResult result = await imagesRef.listAll();

      // Iterate over the files and get the download URL for each image
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }

      // Update the state with the fetched URLs
      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await UserStorage().uploadFile(imageFile);
      await _fetchImageUrls();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Picture'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SW_Sizes.defaultSpace),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Three pictures per row
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image.network(
                            _imageUrls[index],
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Image.network(
                _imageUrls[index],
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                cacheWidth: 120,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SW_Colors.primary,
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
