import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> isUserExists(String userId) async {
    final documentSnapshot =
        await _firestore.collection('users').doc(userId).get();
    return documentSnapshot.exists;
  }

  static void addUser(String userId) {
    _firestore.collection('users').doc(userId).set({'userName': 'flutter'});
  }
}
