import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUsername(String userId) async {
    try {
      // Get the document snapshot for the user
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      
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
}
