import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screen/login_screen.dart';
import './services/firestore_service.dart';
import './screen/chat_screen.dart';
import './screen/input_user_data_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Connect',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.blueAccent,
        fontFamily: 'Open-Sans',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.purple, fontSize: 18),
              subtitle1: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))))),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (userSnapshot.hasData) {
            return FutureBuilder(
                future: FireStoreService.isUserExists(userSnapshot.data.uid),
                builder: (_, isUserExistSnapShot) {
                  if (isUserExistSnapShot.connectionState ==
                      ConnectionState.waiting) return LoadingScreen();
                  if (isUserExistSnapShot.data) return ChatScreen();
                  return InputUserDataScreen(userSnapshot.data.uid);
                });
          }
          return LoginScreen();
        },
      ),
      // routes: {OtpVerifyScreen.routeName: (ctx) => OtpVerifyScreen()},
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SpinKitWave(color: Theme.of(context).primaryColor),
        Text('Wait for a moment', style: Theme.of(context).textTheme.bodyText1)
      ]),
    );
  }
}
