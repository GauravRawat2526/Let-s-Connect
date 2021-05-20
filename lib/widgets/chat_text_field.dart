import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../model/user_data.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatefulWidget {
  final String chatRoomId;
  final String collection;
  ChatTextField({this.chatRoomId, this.collection});
  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  var _message = '';
  final _textController = TextEditingController();

  void _sendMessage() async {
    try {
      FireStoreService.addConversationMessages(
          widget.collection, widget.chatRoomId, {
        'message': _textController.text.trim(),
        'sentBy': Provider.of<UserData>(context, listen: false).userName,
        'createdAt': Timestamp.now()
      });
    } on FirebaseException catch (error) {
      print(error.message);
    }
    _textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Enter your message....',
                border: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColorLight,
              icon: Icon(Icons.send),
              onPressed: _message.trim().isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
