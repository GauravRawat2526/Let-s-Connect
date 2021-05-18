import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';
import '../services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';

class MessageList extends StatefulWidget {
  final String chatRoomId;
  MessageList(this.chatRoomId);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  var stream;
  var isLoading = true;

  @override
  void initState() {
    FireStoreService.getStreamTomessages(widget.chatRoomId).then((value) {
      stream = value;
      setState(() {
        isLoading = false;
      });
    });
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myName = Provider.of<UserData>(context).userName;
    return StreamBuilder(
        stream: stream,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return ListView.builder(
              reverse: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  snapshot.data.docs[index]['message'],
                  snapshot.data.docs[index]['sentBy'] == myName,
                  snapshot.data.docs[index]['sentBy'],
                  key: ValueKey(snapshot.data.docs[index].id),
                );
              });
        });
  }
}
