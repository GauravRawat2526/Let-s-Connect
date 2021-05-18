import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../model/user_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widgets/user_chat_tile.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream chatRoomStream;
  var isLoading = true;
  Widget chatRoomList() {
    try{
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return SpinKitWave(color: Theme.of(context).primaryColor);
        return snapShot.hasData
            ? ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (ctx, index) {
                  return UserChatTile(
                      userName: snapShot.data.docs[index]['chatRoomId']
                          .replaceAll('@', '')
                          .replaceAll(
                              Provider.of<UserData>(context, listen: false)
                                  .userName,
                              ''),
                      chatRoomId: snapShot.data.docs[index]['chatRoomId']);
                },
              )
            : Container();
      },
    );}
      catch(error){
        print('ayush');
        return Container();
      }
  }

  @override
  void initState() {
    FireStoreService.getChatRooms(
            Provider.of<UserData>(context, listen: false).userName)
        .then((value) {
      chatRoomStream = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? SpinKitWave(color: Theme.of(context).primaryColor)
          : chatRoomList(),
    );
  }
}
