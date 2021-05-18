import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final _firestore = FirebaseFirestore.instance;
  
  static Future<bool> isUserExists(String userName) async {
    final documentSnapshot =
        await _firestore.collection('users').doc(userName).get();
    return documentSnapshot.exists;
  }

  static void addId(String userId,String userName){
    _firestore.collection('userIdAndName').doc(userId).set({'userName': userName});
  }
  static void addUser(String userName,String aboutUser,String fullName,String imagePath) {
    print(imagePath);
    _firestore.collection('users').doc(userName).set({'userName': userName,'aboutUser': aboutUser,'fullName':fullName,'imagePath':imagePath});
  }
}
