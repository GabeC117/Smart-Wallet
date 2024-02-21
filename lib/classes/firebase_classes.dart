import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // Handle any errors that occur during the retrieval process
      print('Error setting budget: $e');
      return;
    }
  }
}