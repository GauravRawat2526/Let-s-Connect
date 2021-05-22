import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lets_connect/services/blocs.dart';
import 'package:lets_connect/services/firestore_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_connect/model/user_data.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _imageFile;
  String _uploadFileURL;
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  final _userName = new TextEditingController();
  final _fullName = new TextEditingController();
  final _aboutUser = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Blocs>(context);
    final userData = Provider.of<UserData>(context);
    _uploadFileURL = userData.imageUrl;
    _userName.text = userData.userName;
    _fullName.text = userData.name;
    _aboutUser.text = userData.aboutUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial Rounded",
          ),
        ),
      ),
      body: Builder(
          builder: (context) => Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 80.0,
                            backgroundImage: _imageFile == null
                                ? NetworkImage(userData.imageUrl)
                                : FileImage(File(_imageFile.path)),
                          ),
                          Positioned(
                            bottom: 20.0,
                            right: 20.0,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) =>
                                        bottomSheet(context)));
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 160, height: 40),
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('upload profile',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Arial Rounded",
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.arrow_upward),
                          ],
                        ),
                        onPressed: () async {
                          //setState(() => loading=true);
                          await uploadPic(context, userData);
                          // setState(() => loading=false);
                          print(_uploadFileURL);
                          print('hello');
                          print(userData.userName);
                          print(_aboutUser.text);
                          print(_fullName.text);
                          userData.setUserData(userData.userName,
                              _fullName.text, _uploadFileURL, _aboutUser.text);
                          FireStoreService.addUser(userData.userName,
                              _aboutUser.text, _fullName.text, _uploadFileURL);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => ProfileScreen()));
                          ShowToastNow();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("User Name",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                  Text(userData.userName,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontFamily: "Arial Rounded",
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18.0,
                                      )),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Name",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: "Arial Rounded",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(userData.name,
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18.0,
                                        )),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((builder) => userBottomSheet(
                                      context, bloc, userData)));
                            },
                            child: Icon(
                              MdiIcons.pen,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                MdiIcons.alertCircleOutline,
                                color: Colors.purple,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("About",
                                          style: TextStyle(
                                              fontFamily: "Arial Rounded",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                              fontSize: 18.0)),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(userData.aboutUser,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontFamily: "Arial Rounded",
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((builder) => aboutBottomSheet(
                                      context, bloc, userData)));
                            },
                            child: Icon(
                              MdiIcons.pen,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              )),
    );
  }

  Widget aboutBottomSheet(BuildContext context, Blocs bloc, UserData userData) {
    return Container(
        height: 260.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Edit About User',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Arial Rounded",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            aboutField(bloc),
            SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 140, height: 50),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confirm', style: TextStyle(fontSize: 18)),
                    Icon(Icons.navigate_next)
                  ],
                ),
                onPressed: () {
                  //setState(() => loading=true);
                  // await uploadPic(context,userData);
                  // setState(() => loading=false);
                  print(_uploadFileURL);
                  print('hello');
                  print(userData.userName);
                  print(_aboutUser.text);
                  print(_fullName.text);
                  userData.setUserData(userData.userName, _fullName.text,
                      _uploadFileURL, _aboutUser.text);
                  FireStoreService.addUser(userData.userName, _aboutUser.text,
                      _fullName.text, _uploadFileURL);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                  ShowToastNow();
                },
              ),
            ),
          ],
        ));
  }

  Widget userBottomSheet(BuildContext context, Blocs bloc, UserData userData) {
    return Container(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Edit About User',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Arial Rounded",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            nametextField(bloc),
            SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 140, height: 50),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confirm', style: TextStyle(fontSize: 18)),
                    Icon(Icons.navigate_next)
                  ],
                ),
                onPressed: () {
                  //setState(() => loading=true);
                  //await uploadPic(context,userData);
                  // setState(() => loading=false);
                  print(_uploadFileURL);
                  print('hello');
                  print(userData.userName);
                  print(_aboutUser.text);
                  print(_fullName.text);
                  userData.setUserData(userData.userName, _fullName.text,
                      _uploadFileURL, _aboutUser.text);
                  FireStoreService.addUser(userData.userName, _aboutUser.text,
                      _fullName.text, _uploadFileURL);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                  ShowToastNow();
                },
              ),
            ),
          ],
        ));
  }

  Widget nametextField(Blocs bloc) {
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
              //helperText: "User Name can't empty",
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
              //helperText: "About field can't empty",
              hintText: "About",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeAboutUser,
          );
        });
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

  Future uploadPic(BuildContext context, UserData userData) async {
    try {
      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      var url = await (await uploadTask).ref.getDownloadURL();
      _uploadFileURL = url.toString();
      print(_uploadFileURL);
    } catch (error) {
      _uploadFileURL = userData.imageUrl;
    }
  }

  ShowToastNow() {
    Fluttertoast.showToast(
        msg: "Profile Updated",
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey[700],
        gravity: ToastGravity.BOTTOM);
  }
}

// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool isObscurePassword = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(left: 15, top: 20, right: 15),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 4,
//                           color: Colors.white,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             spreadRadius: 2,
//                             blurRadius: 10,
//                             color: Colors.black.withOpacity(0.1),
//                           ),
//                         ],
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image:
//                                 AssetImage('assets/images/holding_phone.png')),
//                       ),
//                     ),
//                     Positioned(
//                       child: Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             width: 4,
//                             color: Colors.white,
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               buildTextField("full Name", "Dummy User", false),
//               buildTextField("Email", "dummy@email.com", false),
//               buildTextField("Phone Number", "9876543210", false),
//               buildTextField("About", "Busy", false),
//               SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {},
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(
//                         fontSize: 15,
//                         letterSpacing: 2,
//                         color: Colors.black,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 50,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text(
//                       "SAVE",
//                       style: TextStyle(
//                         fontSize: 15,
//                         letterSpacing: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       primary: Theme.of(context).primaryColor,
//                       padding: EdgeInsets.symmetric(horizontal: 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       String labelText, String placeholder, bool isPasswordTextField) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 30),
//       child: TextField(
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.only(bottom: 5),
//           labelText: labelText,
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           hintText: placeholder,
//           hintStyle: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }
