import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a random alphanumeric string for custom ID
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final idLength = 10;
    return List.generate(idLength, (index) => chars[random.nextInt(chars.length)]).join();
  }


  Future<String?> getUsername() async {
    try {
      // Get the document snapshot for the user
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
      
      // Check if the document exists
      if (userSnapshot.exists) {
        // Retrieve the username from the document data
        return userSnapshot.get('username');
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving username: $e');
      return null;
    }
  }




//grabbing budget info
  Future<double?> getBudget() async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('budgets').doc('budget_num').get();

      if (userSnapshot.exists) {
        return userSnapshot.get('num');
      }
      else{
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving username: $e');
      return null;
    }
  }

  Future<void> setBudget (double n) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('budgets').doc('budget_num').get();

      if (userSnapshot.exists){
        await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('budgets').doc('budget_num').update({
          'num': n,
        });
      }else{
        await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('budgets').doc('budget_num').set({
          'num': n,
        });
      }
      return;

    } catch (e) {

      print('Error setting budget: $e');
      return;
    }
  }

  Future<List<Map<String, dynamic>>?> getRecentExpenses() async {
    try {
      // Get reference to Firestore collection
      CollectionReference expenses = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot = await expenses.orderBy('createdAt', descending: true).limit(3).get(); // Limit to 3 most recent expenses

      // Initialize a list to store maps of amount, category, and id
      List<Map<String, dynamic>> exList = [];

      // Iterate over each document to extract amount, category, and id
      querySnapshot.docs.forEach((doc) {
        // Get the amount, category, and id from the document data
        double amount = doc.get('amount') ?? 0.0;
        String category = doc.get('category') ?? '';
        String id = doc.id; // Get the document ID

        // Create a map containing amount, category, and id
        Map<String, dynamic> exMap = {
          'id': id,
          'amount': amount,
          'category': category,
        };

        // Add the map to the list
        exList.add(exMap);
      });

      // Return the list of maps
      return exList;
    } catch (e) {
      // Handle errors here
      print('Error: $e');
      return null;
    }
  }


  Future<void> setEx(double amount, String category) async {
    try {
      // Get reference to Firestore collection
      CollectionReference expenses = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('expenses');
      String customId = _generateRandomId();

      // Add a new document to the expenses collection with custom ID
      await expenses.doc(customId).set({
        'amount': amount,
        'category': category,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp indicating creation time
      });
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }


  Future<double?> getExAmount() async{
    //grab all amounts from all docs and return the addition of them all
    try {
      // Get reference to Firestore collection
      CollectionReference expenses = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot = await expenses.orderBy('createdAt', descending: true).get();

      // Initialize total amount variable
      double totalAmount = 0.0;

      // Iterate over each document to extract and sum the amounts
      querySnapshot.docs.forEach((doc) {
        // Get the amount from the document data
        double amount = doc.get('amount') ?? 0.0;
        // Add the amount to the total
        totalAmount += amount;
      });

      // Return the total amount
      return totalAmount;
    } catch (e) {
      // Handle errors here
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getExMap() async {
    try {
      // Get reference to Firestore collection
      CollectionReference expenses = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot = await expenses.orderBy('createdAt', descending: true).get();

      // Initialize a list to store maps of amount, category, and id
      List<Map<String, dynamic>> exList = [];

      // Iterate over each document to extract amount, category, and id
      querySnapshot.docs.forEach((doc) {
        // Get the amount, category, and id from the document data
        double amount = doc.get('amount') ?? 0.0;
        String category = doc.get('category') ?? '';
        String id = doc.id; // Get the document ID

        // Create a map containing amount, category, and id
        Map<String, dynamic> exMap = {
          'id': id,
          'amount': amount,
          'category': category,
        };

        // Add the map to the list
        exList.add(exMap);
      });

      // Return the list of maps
      return exList;
    } catch (e) {
      // Handle errors here
      print('Error: $e');
      return null;
    }
  }

  
  Future<void> deleteExpense(String expenseId) async {
    try {
      // Get reference to the expense document
      CollectionReference expenses = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('expenses');
      
      // Delete the expense document using the provided expenseId
      await expenses.doc(expenseId).delete();
    } catch (e) {
      // Handle errors here
      print('Error deleting expense: $e');
      throw e; // Rethrow the error to handle it in the calling code
    }
  }

}

class UserStorage {
  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(File file) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('images/${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() => print('File Uploaded'));
    } catch (e) {
      print(e);
    }
  }

}