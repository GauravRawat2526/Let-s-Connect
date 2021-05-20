import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final _message;
  final isMe;
  final key;
  final userName;
  final Timestamp createdAt;
  MessageBubble(this._message, this.isMe, this.userName, this.createdAt,
      {this.key});
  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(createdAt.toDate());
    return Row(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) Text(time, style: TextStyle(fontSize: 11)),
          Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                  color: isMe ? Theme.of(context).accentColor : Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft:
                          isMe ? Radius.circular(20) : Radius.circular(0),
                      bottomRight:
                          isMe ? Radius.circular(0) : Radius.circular(20))),
              constraints:
                  BoxConstraints(minHeight: 50, maxWidth: 240, minWidth: 100),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Text(
                        userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ])),
          if (isMe)
            Text(
              time,
              style: TextStyle(fontSize: 11),
            ),
        ]);
  }
}
