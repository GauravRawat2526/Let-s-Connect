import 'package:flutter/material.dart';

import '../services/phone_auth.dart';
import '../screen/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Dummy'),
            accountEmail: Text('dummy@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/holding_phone.png'),
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
