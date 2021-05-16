import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import './chat_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputUserDataScreen extends StatefulWidget {
  final String _userId;
  InputUserDataScreen(this._userId);
  @override
  _InputUserDataScreenState createState() => _InputUserDataScreenState();
}

class _InputUserDataScreenState extends State<InputUserDataScreen> {
  @override
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      //padding: EdgeInsets.all(70.0),
      child: ListView(
        children: [
          imageProfile(),
          SizedBox(
            height: 30,
          ),
          nametextField(),
          SizedBox(
            height: 30,
          ),
          aboutField(),
          SizedBox(
            height: 30,
          ),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: mediaQuery.size.width, height: 50),
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Confirm', style: TextStyle(fontSize: 18)),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                  onPressed: () {
                    FireStoreService.addUser(widget._userId);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => ChatScreen()));
                  })),
        ],
      ),
    ));
  }

  Widget imageProfile() {
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
                    context: context, builder: ((builder) => bottomSheet()));
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

  Widget bottomSheet() {
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
    final pickerFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickerFile;
    });
  }

  Widget nametextField() {
    return TextFormField(
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
      ),
    );
  }

  Widget aboutField() {
    return TextFormField(
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
      ),
    );
  }
}
