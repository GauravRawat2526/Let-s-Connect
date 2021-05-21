import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/message_list.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String aboutUser;
  final String imageUrl;
  final String name;
  final String chatRoomId;
  ConversationScreen(
      {@required this.aboutUser,
      @required this.imageUrl,
      @required this.name,
      @required this.userName,
      @required this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
          title: Text(widget.userName),
        ),
        onTap: () => print('appBar'),
      ),
      body: Column(
        children: [
          Expanded(
              child: MessageList(
                  collectionName: 'ChatRoom', chatRoomId: widget.chatRoomId)),
          ChatTextField(
            collection: 'ChatRoom',
            chatRoomId: widget.chatRoomId,
          )
        ],
      ),
    );
  }
}
