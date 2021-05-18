import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './input_user_data_screen.dart';
import './tabs_screen.dart';
import './loadingScreen.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';
class HomePage extends StatelessWidget {
  static const routeName = '/homepage';
  @override
  Widget build(BuildContext context) {
    final myName = Provider.of<UserData>(context , listen: false).userName;
    return FutureBuilder(
        future: FireStoreService.isUserExists(myName),
        builder: (_, isUserExistSnapShot) {
          if (isUserExistSnapShot.connectionState == ConnectionState.waiting)
            return LoadingScreen();
          if (isUserExistSnapShot.data) return TabsScreen();
          return InputUserDataScreen(FirebaseAuth.instance.currentUser.uid);
        });
  }
}
