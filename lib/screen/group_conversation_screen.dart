import 'package:flutter/material.dart';
import 'package:lets_connect/widgets/group_profile.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/message_list.dart';

class GroupConversationScreen extends StatefulWidget {
  final String groupName;
  final String imageUrl;
  final users;
  GroupConversationScreen(
      {@required this.groupName,
      @required this.imageUrl,
      @required this.users});
  _GroupConversationScreenState createState() =>
      _GroupConversationScreenState();
}

class _GroupConversationScreenState extends State<GroupConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          actions: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            )
          ],
          title: Text(widget.groupName),
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => GroupProfile(groupName:widget.groupName,imageUrl: widget.imageUrl, users: widget.users,)));
        },
      ),
      body: Column(
        children: [
          Expanded(
              child: MessageList(
                  collectionName: 'GroupChatRoom',
                  chatRoomId: widget.groupName)),
          ChatTextField(
              collection: 'GroupChatRoom', chatRoomId: widget.groupName)
        ],
      ),
    );
  }
}
