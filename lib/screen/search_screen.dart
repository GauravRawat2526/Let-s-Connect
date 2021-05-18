import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_connect/services/firestore_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var isLoading = false;
  final _searchFieldController = TextEditingController();
  DocumentSnapshot documentSnapshot;
  var haveUserSearched = false;
  Widget buildSearchTile(BuildContext context) {
    if (documentSnapshot == null) return Container();
    if (haveUserSearched && !documentSnapshot.exists) {
      showSnackBarError(context, 'User Not Exist');
      return Container();
    }

    return SearchTile(
        imageUrl: documentSnapshot['imageUrl'],
        userName: documentSnapshot['userName'],
        name: documentSnapshot['name'],
        createChatRoom: createChatRoom);
  }

  createChatRoom(String userName) async {
    print(userName);
    final myName = Provider.of<UserData>(context, listen: false).userName;
    List<String> users = [userName, myName];
    Map<String, dynamic> chatRoomMap = {
      'chatRoomId': '$userName@$myName',
      'users': users
    };
    setState(() {
      isLoading = true;
    });
    await FireStoreService.createChatRoom(chatRoomMap);
    setState(() {
      isLoading = false;
      haveUserSearched = false;
      documentSnapshot = null;
      _searchFieldController.text = '';
    });
  }

  showSnackBarError(BuildContext context, String msg) async {
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        duration: Duration(seconds: 1),
        content: Text(msg, textAlign: TextAlign.center)));
  }

  @override
  Widget build(BuildContext context) {
    final myName = Provider.of<UserData>(context, listen: false).userName;
    return isLoading
        ? SpinKitWave(color: Theme.of(context).primaryColor)
        : Column(children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextField(
                        autocorrect: false,
                        controller: _searchFieldController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Search username',
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight,
                                width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        )),
                  ),
                ),
                Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () async {
                        if (myName == _searchFieldController.text.trim()) {
                          showSnackBarError(
                              context, 'You can\'t search yourself');
                          return;
                        }
                        setState(() {
                          isLoading = true;
                          haveUserSearched = true;
                        });
                        documentSnapshot =
                            await FireStoreService.searchUserByUsername(
                                _searchFieldController.text.trim());
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ))
              ],
            ),
            buildSearchTile(context)
          ]);
  }
}

class SearchTile extends StatelessWidget {
  final imageUrl;
  final userName;
  final name;
  final Function createChatRoom;
  SearchTile(
      {@required this.userName,
      @required this.name,
      @required this.imageUrl,
      @required this.createChatRoom});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(userName),
      subtitle: Text(name),
      trailing: GestureDetector(
        onTap: () => createChatRoom(userName),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20)),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minWidth: 80,
            maxWidth: 100,
            minHeight: 30,
            maxHeight: 40,
          ),
          child: Text('Message',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
