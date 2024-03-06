import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      Reference imagesRef = storage.ref().child('images/${FirebaseAuth.instance.currentUser?.uid}');

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
        title: Text('Take a Picture'),
      ),
      body: ListView.builder(
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Image.network(
              _imageUrls[index],
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
