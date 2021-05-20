import 'package:flutter/material.dart';
import './search_screen.dart';
import './chat_screen.dart';
import './status_screen.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/app_drawer.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './groups_chat_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _scrAndName;
  int _selectedPageIndex = 0;
  var isLoading = true;
  @override
  void initState() {
    _scrAndName = [
      {'screen': ChatScreen(), 'name': 'Categories'},
      {'screen': GroupsChatScreen(), 'name': 'GroupsChatScreen'},
      {'screen': SearchScreen(), 'name': 'Favourites'},
      {'screen': StatusScreen(), 'name': 'StatusScreen'},
    ];
    getUserName().then((userName) {
      print(userName);
      getUserDataByUserName(userName).then((userData) {
        Provider.of<UserData>(context, listen: false).setUserData(
            userData['userName'],
            userData['name'],
            userData['imageUrl'],
            userData['aboutUser']);
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  Future<String> getUserName() async {
    return await FireStoreService.getUserNameById(
        FirebaseAuth.instance.currentUser.uid);
  }

  Future getUserDataByUserName(String userName) async {
    return await FireStoreService.getUserDataByUserName(userName);
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Connect',
        ),
        elevation: 0,
      ),
      drawer: isLoading ? null : AppDrawer(),
      body: isLoading
          ? SpinKitWave(color: Theme.of(context).primaryColor)
          : _scrAndName[_selectedPageIndex]['screen'],
      bottomNavigationBar: CurvedNavigationBar(
          index: _selectedPageIndex,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          items: [
            Icon(
              MdiIcons.commentTextMultiple,
              color: Colors.white,
            ),
            Icon(
              Icons.group,
              color: Colors.white,
            ),
            Icon(
              MdiIcons.magnify,
              color: Colors.white,
            ),
            Icon(
              MdiIcons.wallpaper,
              color: Colors.white,
            ),
          ],
          onTap: selectPage),
    );
  }
}
