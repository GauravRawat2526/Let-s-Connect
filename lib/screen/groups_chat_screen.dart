import 'package:flutter/material.dart';
import '../widgets/add_users_to_group.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';
import './group_conversation_screen.dart';

class GroupsChatScreen extends StatefulWidget {
  @override
  _GroupsChatScreenState createState() => _GroupsChatScreenState();
}

class _GroupsChatScreenState extends State<GroupsChatScreen> {
  Stream groupChatRoomStream;
  var isLoading = true;

  @override
  void initState() {
    FireStoreService.getChatRooms('GroupChatRoom',
            Provider.of<UserData>(context, listen: false).userName)
        .then((value) {
      groupChatRoomStream = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Widget chatRoomList() {
    try {
      return StreamBuilder(
        stream: groupChatRoomStream,
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return SpinKitWave(color: Theme.of(context).primaryColor);
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    return GroupChatTile(
                      groupName: snapShot.data.docs[index]['groupName'],
                      imageUrl: snapShot.data.docs[index]['imageUrl'],
                      users: snapShot.data.docs[index]['users'],
                    );
                  },
                )
              : Container();
        },
      );
    } catch (error) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? SpinKitWave(color: Theme.of(context).primaryColor)
          : chatRoomList(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.group_add_sharp),
          onPressed: showUsersInMoalBottomSheet),
    );
  }

  showUsersInMoalBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AddUsersToGroup();
        });
  }
}

class GroupChatTile extends StatelessWidget {
  final imageUrl;
  final groupName;
  final users;
  GroupChatTile(
      {@required this.imageUrl,
      @required this.groupName,
      @required this.users});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => GroupConversationScreen(
                groupName: groupName, imageUrl: imageUrl, users: users)));
      },
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(groupName),
      ),
    );
  }
}
