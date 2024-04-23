import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a random alphanumeric string for custom ID
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final idLength = 10;
    return List.generate(
        idLength, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<String?> getUsername() async {
    try {
      // Get the document snapshot for the user
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Retrieve the username from the document data
        return userSnapshot.get('username');
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }

  Future<String?> getEmail() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        return snapshot.get('email') as String?;
      } catch (e) {
        print('Error getting email: $e');
      }
    }
    return null;
  }

  Future<void> updateUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'username': newUsername,
        });
      } catch (e) {
        print('Error updating username: $e');
        throw e;
      }
    }
  }

  Future<void> updateEmail(String newEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await currentUser.updateEmail(newEmail);
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'email': newEmail});
      } catch (e) {
        print('Error updating email: $e');
      }
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'profilePicture': imageUrl,
      });
    } catch (e) {
      print('Error updating profile picture: $e');
      throw e;
    }
  }

//grabbing budget info
  Future<double?> getBudget() async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('budgets')
          .doc('budget_num')
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('num');
      } else {
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      print('Error retrieving username: $e');
      return null;
    }
  }

  Future<void> setBudget(double n) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('budgets')
          .doc('budget_num')
          .get();

      if (userSnapshot.exists) {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('budgets')
            .doc('budget_num')
            .update({
          'num': n,
        });
      } else {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('budgets')
            .doc('budget_num')
            .set({
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
      CollectionReference expenses = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot = await expenses
          .orderBy('createdAt', descending: true)
          .limit(3)
          .get(); // Limit to 3 most recent expenses

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

 
  Future<void> setEx(double amount, String category, String? imageUrl) async {
    try {
      CollectionReference expenses = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses');
      String customId = _generateRandomId();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss a').format(now);

      await expenses.doc(customId).set({
        'amount': amount,
        'category': category,
        'imageUrl': imageUrl, // Store the image URL
        'createdAt': formattedDate,
      });
    } catch (e) {
      print('Error setting expense: $e');
    }
  }

 Future<double?> getCategoryBudget(String category) async {
    try {
      DocumentSnapshot budgetSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('budgets')
          .doc(category)
          .get();

      if (budgetSnapshot.exists) {
        return budgetSnapshot.get('amount');
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving category budget: $e');
      return null;
    }
  }

  Future<void> setCategoryBudget(String category, double amount) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('budgets')
          .doc(category)
          .set({
        'category': category,
        'amount': amount,
      });
    } catch (e) {
      print('Error setting category budget: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryExpenses(
      String category) async {
    try {
      List<Map<String, dynamic>> expenses = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      querySnapshot.docs.forEach((doc) {
        expenses.add({
          'id': doc.id,
          'amount': doc.get('amount'),
          'category': doc.get('category'),
          'createdAt': doc.get('createdAt')
        });
      });

      return expenses;
    } catch (e) {
      print('Error fetching expenses for category $category: $e');
      return [];
    }
  }

  Future<double?> getExAmount() async {
    //grab all amounts from all docs and return the addition of them all
    try {
      // Get reference to Firestore collection
      CollectionReference expenses = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot =
          await expenses.orderBy('createdAt', descending: true).get();

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
      CollectionReference expenses = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses');

      // Get documents snapshot
      QuerySnapshot querySnapshot =
          await expenses.orderBy('createdAt', descending: true).get();

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
      CollectionReference expenses = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('expenses');

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
