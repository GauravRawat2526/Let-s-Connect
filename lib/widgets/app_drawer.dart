import 'package:flutter/material.dart';

import '../services/phone_auth.dart';
import '../screen/profile_screen.dart';
import '../model/user_data.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userData.userName),
            accountEmail: Text(userData.name),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userData.imageUrl),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
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
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: Text('Logout'),
            onTap: () {
              PhoneAuth.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
