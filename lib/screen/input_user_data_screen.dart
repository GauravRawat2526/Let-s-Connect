import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_connect/screen/tabs_screen.dart';
import 'package:lets_connect/services/firestore_service.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_connect/services/blocs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputUserDataScreen extends StatefulWidget {
  final String userId;
  InputUserDataScreen(this.userId);
  @override
  _InputUserDataScreenState createState() => _InputUserDataScreenState();
}

class _InputUserDataScreenState extends State<InputUserDataScreen> {
  //String ans;
  File _imageFile;
  String _uploadFileURL;
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  final _userName = new TextEditingController();
  final _fullName = new TextEditingController();
  final _aboutUser = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bloc = Provider.of<Blocs>(context);
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              imageProfile(context),
              SizedBox(
                height: 20,
              ),
              nametextField(bloc),
              SizedBox(
                height: 20,
              ),
              fullNameField(bloc),
              SizedBox(
                height: 20,
              ),
              aboutField(bloc),
              SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: mediaQuery.size.width, height: 50),
                child: StreamBuilder<Object>(
                    stream: bloc.userValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Confirm', style: TextStyle(fontSize: 18)),
                            Icon(Icons.navigate_next)
                          ],
                        ),
                        onPressed: !snapshot.hasData
                            ? null
                            : () async {
                                setState(() => loading = true);
                                await uploadPic(context);
                                print(_uploadFileURL);
                                print('hello');
                                await FireStoreService.addUser(
                                    _userName.text,
                                    _aboutUser.text,
                                    _fullName.text,
                                    _uploadFileURL);
                                await FireStoreService.addId(
                                    widget.userId, _userName.text);
                                setState(() => loading = false);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (ctx) => TabsScreen()));
                              },
                      );
                    }),
              ),
            ],
          ),
        ),
        if (loading) Center(child: CircularProgressIndicator()),
      ]),
    );
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? AssetImage('assets/images/holding_phone.png')
                : FileImage(File(_imageFile.path)),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet(context)));
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Choose Profile photo',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Arial Rounded",
              ),
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
                    takePhoto(ImageSource.camera);
                  },
                  label: Text('Camera',
                      style: TextStyle(
                        fontFamily: "Arial Rounded",
                      )),
                ),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text('Gallery',
                      style: TextStyle(
                        fontFamily: "Arial Rounded",
                      )),
                )
              ],
            )
          ],
        ));
  }

  void takePhoto(ImageSource source) async {
    print(source);
    final pickerFile = await _picker.getImage(source: source, imageQuality: 50);
    setState(() {
      _imageFile = File(pickerFile.path);
    });
  }

  Widget nametextField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.userName,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _userName,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.purple,
              ),
              labelText: "User Name",
              helperText: "User Name can't empty",
              hintText: "User Name",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeUserName,
          );
        });
  }

  Widget fullNameField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.fullName,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _fullName,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.purple,
              ),
              labelText: "Name",
              helperText: "Name can't empty",
              hintText: "Name",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeFullName,
          );
        });
  }

  Widget aboutField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.aboutUser,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _aboutUser,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                MdiIcons.alertCircleOutline,
                color: Colors.purple,
              ),
              labelText: "About",
              helperText: "About field can't empty",
              hintText: "About",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeAboutUser,
          );
        });
  }

  Future uploadPic(BuildContext context) async {
    try {
      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      var url = await (await uploadTask).ref.getDownloadURL();
      _uploadFileURL = url.toString();
      print(_uploadFileURL);
    } catch (error) {
      print('null value');
    }
  }
}
