import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './input_user_data_screen.dart';
import './chat_screen.dart';
import './loadingScreen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homepage';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FireStoreService.isUserExists(
            FirebaseAuth.instance.currentUser.uid),
        builder: (_, isUserExistSnapShot) {
          if (isUserExistSnapShot.connectionState == ConnectionState.waiting)
            return LoadingScreen();
          if (isUserExistSnapShot.data) return ChatScreen();
          return InputUserDataScreen(FirebaseAuth.instance.currentUser.uid);
        });
  }
}
