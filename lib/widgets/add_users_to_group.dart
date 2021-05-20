import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../model/user_data.dart';
import 'package:provider/provider.dart';

class AddUsersToGroup extends StatefulWidget {
  AddUsersToGroup({Key key}) : super(key: key);

  @override
  _AddUsersToGroupState createState() => _AddUsersToGroupState();
}

class _AddUsersToGroupState extends State<AddUsersToGroup> {
  final usersToAddInGroup = [];
  var querySnapshot;
  var isLoading = true;
  final _formKey = GlobalKey<FormState>();
  var groupName;
  bool alreadyExists = false;
  @override
  void initState() {
    final myName = Provider.of<UserData>(context, listen: false).userName;
    usersToAddInGroup.add(myName);
    FireStoreService.getCollection('users', myName).then((value) {
      querySnapshot = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  addUser(String userName) {
    usersToAddInGroup.add(userName);
    print(usersToAddInGroup);
  }

  removeUser(String userName) {
    usersToAddInGroup.remove(userName);
    print(usersToAddInGroup);
  }

  createGroupChatRoom() async {
    _formKey.currentState.save();

    if (!_formKey.currentState.validate()) {
      return;
    }
    if (await FireStoreService.isGroupExist(groupName)) {
      alreadyExists = true;
      _formKey.currentState.validate();
      alreadyExists = false;
      return;
    }
    // mahe chat Rooom
    Map<String, dynamic> data = {
      'groupName': groupName,
      'users': usersToAddInGroup,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/let-s-connect-c92a2.appspot.com/o/scaled_image_picker8861404749849128044.jpg?alt=media&token=0b8a2615-5507-4a19-ab14-d8b7ba17d3c4',
    };
    setState(() {
      isLoading = true;
    });
    await FireStoreService.createGroupChatRoom(groupName, data);
    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Group Name too short';
                        }
                        if (alreadyExists) {
                          return 'Group Name already exists';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        groupName = value;
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Enter Group Name....',
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorLight,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      )),
                ),
              ),
              TextButton(onPressed: createGroupChatRoom, child: Icon(Icons.add))
            ],
          ),
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (ctx, index) {
                      return AddGroupTile(
                        userName: querySnapshot.docs[index]['userName'],
                        name: querySnapshot.docs[index]['name'],
                        imageUrl: querySnapshot.docs[index]['imageUrl'],
                        addUser: addUser,
                        removerUser: removeUser,
                      );
                    }))
      ],
    );
  }
}

class AddGroupTile extends StatefulWidget {
  final imageUrl;
  final userName;
  final name;
  final Function addUser;
  final Function removerUser;
  AddGroupTile(
      {@required this.userName,
      @required this.name,
      @required this.imageUrl,
      @required this.removerUser,
      @required this.addUser});

  @override
  _AddGroupTileState createState() => _AddGroupTileState();
}

class _AddGroupTileState extends State<AddGroupTile> {
  var buttonText = 'Add';

  removeOrAdd() {
    if (buttonText == 'Add') {
      widget.addUser(widget.userName);
      setState(() {
        buttonText = 'Remove';
      });
    } else {
      widget.removerUser(widget.userName);
      setState(() {
        buttonText = 'Add';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      title: Text(widget.userName),
      subtitle: Text(widget.name),
      trailing: GestureDetector(
        onTap: removeOrAdd,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20)),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minWidth: 80,
            maxWidth: 100,
            minHeight: 30,
            maxHeight: 40,
          ),
          child: Text(buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
