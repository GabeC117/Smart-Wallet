import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Other imports...

class PicturePage extends StatefulWidget {
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  List<String> _imageUrls = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      Reference imagesRef = _storage.ref().child('images/$userId');
      ListResult result = await imagesRef.listAll();
      List<String> urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
      setState(() => _imageUrls = urls);
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // Process for storing the new image and linking it to an expense should be implemented here
      _fetchImageUrls();
    }
  }

  void _showExpenseDetails(String imageUrl) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      var expensesSnapshot = await _firestore
          .collection('users/$userId/expenses')
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      if (expensesSnapshot.docs.isEmpty) {
        _showNoExpenseFoundDialog();
        return;
      }

      var expenseData = expensesSnapshot.docs.first.data();
      _showExpenseDetailDialog(imageUrl, expenseData);
    } catch (e) {
      print('Error fetching expense details: $e');
    }
  }

  void _showNoExpenseFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Expense Found'),
          content: Text('No expense details found for this image.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showExpenseDetailDialog(String imageUrl, Map<String, dynamic> expenseData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Expense Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.network(imageUrl, fit: BoxFit.cover),
                Text("Amount: \$${expenseData['amount']}"),
                Text("Category: ${expenseData['category']}"),
                Text("Date: ${expenseData['createdAt']}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reciepts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _imageUrls.isEmpty
            ? Center(child: Text('No images found. Tap "+" to add new images.'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showExpenseDetails(_imageUrls[index]),
                    child: Image.network(
                      _imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
