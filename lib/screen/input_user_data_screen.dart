import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import './chat_screen.dart';

class InputUserDataScreen extends StatelessWidget {
  final String _userId;
  InputUserDataScreen(this._userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: TextButton(
                child: Text('Save'),
                onPressed: () {
                  FireStoreService.addUser(_userId);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => ChatScreen()));
                })),
      ),
    );
  }
}
