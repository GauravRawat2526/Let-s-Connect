import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../screen/conversation_screen.dart';

class UserChatTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  UserChatTile({@required this.userName, @required this.chatRoomId});

  @override
  _UserChatTileState createState() => _UserChatTileState();
}

class _UserChatTileState extends State<UserChatTile> {
  var isLoading = true;

  String imageUrl;
  String aboutUser;
  String name;
  @override
  void initState() {
    FireStoreService.searchUserByUsername(widget.userName).then((value) {
      imageUrl = value['imageUrl'];
      aboutUser = value['aboutUser'];
      name = value['name'];
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center()
        : Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                            aboutUser: aboutUser,
                            name: name,
                            userName: widget.userName,
                            chatRoomId: widget.chatRoomId,
                            imageUrl: imageUrl,
                          )));
                },
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(widget.userName)),
              ),
            ),
            Divider(thickness: 2)
          ]);
  }
}
