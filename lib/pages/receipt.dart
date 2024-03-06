import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class PicturePage extends StatefulWidget {
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  late File? _imageFile = null;
  final _picker = ImagePicker();
  
  
  Future<void> _takePicture() async {
    final imageFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(imageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a Picture'),
      ),
      body: Center(
        child: _imageFile == null
            ? Text('No image selected.')
            : Image.file(_imageFile!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
