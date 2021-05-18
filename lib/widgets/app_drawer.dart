import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lets_connect/screen/onboarding_screen.dart';
import 'package:lets_connect/services/firestore_service.dart';

import '../services/phone_auth.dart';
import '../screen/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  String ans;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Dummy'),
            accountEmail: Text('dummy@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/holding_phone.png'),
            ),
          ),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen()));
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              PhoneAuth.logout();
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>OnboardingScreen()));
            },
          ),
        ],
      ),
    );
  }
  Future<Widget> _getImage(BuildContext context,String imageName) async{
    Image image;
    await FireStorage.loadImage(context, imageName).then((value){
      ans=value.toString();
    });
  }
}

class FireStorage extends ChangeNotifier{
  FireStorage();
  static Future<dynamic>loadImage(BuildContext context,String Image)async{
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}