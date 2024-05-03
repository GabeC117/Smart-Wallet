import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_wallet/classes/firebase_classes.dart';

class AddExpense extends StatefulWidget {
  final VoidCallback? onUpdateBudgetPage; // Callback function

  AddExpense({this.onUpdateBudgetPage});

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _expenseController = TextEditingController();
  String _selectedCategory = 'Select a Category';
  final List<String> _categories = [
    'Select a Category',
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Other',
  ];
  File? _image;
  final _picker = ImagePicker();
  TextEditingController? _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadExpenseWithImage(
      double expense, String category, File? imageFile, String? desc) async {
    String? imageUrl;
    // Upload the image to Firebase Storage if it exists
    if (imageFile != null) {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String fileName = 'expense_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$userId/$fileName');
      await storageRef.putFile(imageFile);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Upload the expense to the database with the image URL
    UserDatabase userDatabase = UserDatabase();
    await userDatabase.setEx(expense, category, imageUrl, desc);

    // Show a pop-up to inform the user that the expense was saved successfully
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Expense Saved'),
          content: Text('Your expense has been saved successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _expenseController.clear();
    _descriptionController?.clear();
    setState(() {
      _selectedCategory = 'Select a Category';
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onUpdateBudgetPage?.call();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select a Category',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter an expense',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(_image!),
              ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Enter a description (optional)',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedCategory == 'Select a Category') {
                  // Show a pop-up to inform the user that selecting a category is required
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Category Not Selected'),
                        content: Text('Please select a category.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final double expense =
                      double.tryParse(_expenseController.text) ?? 0.0;
                  final String? description =
                      _descriptionController?.text; // Retrieve description text
                  _uploadExpenseWithImage(expense, _selectedCategory, _image,
                      description); // Pass description
                  _resetForm();
                }
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
