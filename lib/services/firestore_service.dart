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

  static getChatRooms(String userName) async {
    return _firestore
        .collection('ChatRoom')
        .where("users", arrayContains: userName)
        .snapshots();
  }

  static addConversationMessages(String chatRoomId, messageMap) async {
    _firestore
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  static getStreamTomessages(String chatRoomId) async {
    return _firestore
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
