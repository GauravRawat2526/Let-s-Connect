import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screen/loadingScreen.dart';
import './screen/login_screen.dart';
import './screen/home_page.dart';

BuildContext globalContext;
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
      home: RoutingScreen(),
      routes: {
        RoutingScreen.routeName: (_) => RoutingScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        HomePage.routeName: (_) => HomePage()
      },
    );
  }
}

class RoutingScreen extends StatefulWidget {
  static const routeName = '/RoutingScreen';
  const RoutingScreen({
    Key key,
  }) : super(key: key);

  @override
  _RoutingScreenState createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() async {
    await Future.delayed(Duration(seconds: 1));
    print(FirebaseAuth.instance.currentUser);
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}
