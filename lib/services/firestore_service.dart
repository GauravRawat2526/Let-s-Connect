import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> isUserExists(String userId) async {
    final documentSnapshot =
        await _firestore.collection('userIdAndName').doc(userId).get();
    return documentSnapshot.exists;
  }

  static Future addId(String userId, String userName) async {
    _firestore
        .collection('userIdAndName')
        .doc(userId)
        .set({'userName': userName});
  }

  static Future addUser(String userName, String aboutUser, String fullName,
      String imagePath) async {
    print(imagePath);
    _firestore.collection('users').doc(userName).set({
      'userName': userName,
      'aboutUser': aboutUser,
      'name': fullName,
      'imageUrl': imagePath
    });
  }

  static searchUserByUsername(String userName) async {
    return await _firestore.collection('users').doc(userName).get();
  }

  static Future<String> getUserNameById(String userId) async {
    final ds = await _firestore.collection('userIdAndName').doc(userId).get();
    return ds['userName'];
  }

  static Future<DocumentSnapshot> getUserDataByUserName(String userName) async {
    return await _firestore.collection('users').doc(userName).get();
  }

  static createChatRoom(chatRoomMap) async {
    await _firestore
        .collection('ChatRoom')
        .doc(chatRoomMap['chatRoomId'])
        .set(chatRoomMap);
  }

  static getChatRooms(String room, String userName) async {
    return _firestore
        .collection(room)
        .where("users", arrayContains: userName)
        .snapshots();
  }

  static addConversationMessages(
      String collection, String chatRoomId, messageMap) async {
    _firestore
        .collection(collection)
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  static getStreamTomessages(String collectionName, String chatRoomId) async {
    return _firestore
        .collection(collectionName)
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      collectionName, String notIncludeMyName) async {
    return await _firestore
        .collection(collectionName)
        .where('userName', isNotEqualTo: notIncludeMyName)
        .get();
  }

  static Future createGroupChatRoom(String groupName, map) async {
    await _firestore.collection('GroupChatRoom').doc(groupName).set(map);
  }

  static Future<bool> isGroupExist(String groupName) async {
    final document =
        await _firestore.collection('GroupChatRoom').doc(groupName).get();
    return document.exists;
  }
}
