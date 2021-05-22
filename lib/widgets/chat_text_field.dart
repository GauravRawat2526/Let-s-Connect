import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File _imageFile;
  final _picker = ImagePicker();
  String _uploadFileURL;
  var isLoading = false;
  _sendMessage(String messageType) async {
    try {
      FireStoreService.addConversationMessages(
          widget.collection, widget.chatRoomId, {
        'message': messageType == 'image'
            ? _uploadFileURL
            : _textController.text.trim(),
        'sentBy': Provider.of<UserData>(context, listen: false).userName,
        'createdAt': Timestamp.now(),
        'messageType': messageType
      });
    } on FirebaseException catch (error) {
      print(error.message);
    }
    _textController.text = '';
  }

  Future uploadPic(BuildContext context) async {
    try {
      String fileName = _imageFile.path.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      setState(() {
        isLoading = true;
      });
      var url = await (await uploadTask).ref.getDownloadURL();
      _uploadFileURL = url.toString();
      print(_uploadFileURL);
    } catch (error) {
      print('null value');
    }
    await _sendMessage('image');
    setState(() {
      isLoading = false;
    });
  }

  void takePhoto(ImageSource source, BuildContext context) async {
    print(source);
    final pickerFile = await _picker.getImage(source: source, imageQuality: 30);
    setState(() async {
      _imageFile = File(pickerFile.path);
      FocusManager.instance.primaryFocus.unfocus();
      await uploadPic(context);
    });
  }

  bottomSheet(BuildContext context) {
    showBottomSheet(
      backgroundColor: Theme.of(context).primaryColorLight,
      context: context,
      builder: (ctx) => Container(
          height: 150.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: GestureDetector(
                  child: Text(
                    'Send Doodle',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "Arial Rounded",
                    ),
                  ),
                  onTap: () => print(''),
                ),
              ),
              Divider(color: Colors.black),
              Container(
                child: Column(
                  children: [
                    Text(
                      'Send Image',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Arial Rounded",
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.camera),
                          onPressed: () {
                            takePhoto(ImageSource.camera, context);
                          },
                          label: Text('Camera',
                              style: TextStyle(
                                fontFamily: "Arial Rounded",
                              )),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            takePhoto(ImageSource.gallery, context);
                          },
                          label: Text('Gallery',
                              style: TextStyle(
                                fontFamily: "Arial Rounded",
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
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
              icon: isLoading ? CircularProgressIndicator() : Icon(Icons.image),
              onPressed: () => bottomSheet(context)),
          IconButton(
              color: Theme.of(context).primaryColorLight,
              icon: Icon(Icons.send),
              onPressed:
                  _message.trim().isEmpty ? null : () => _sendMessage('text'))
        ],
      ),
    );
  }
}
