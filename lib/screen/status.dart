import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:lets_connect/widgets/app_drawer.dart';
//import 'package:toast/toast.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  static final _firestore = FirebaseFirestore.instance;
  final fb=FirebaseDatabase.instance.reference().child('MyImages');
  final ImagePicker _picker = ImagePicker();
  List<String> itemList=new List();
  File image;
  String _uploadFileURL;
  String CreateCryptoRandomString([int length = 32]){
    final Random _random=Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          takeImage();
        },
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState(){
    _firestore.collection('MyImages').get().then((querySnapshot){
      itemList.clear();
      querySnapshot.docs.forEach((result) {
        itemList.add(result['link']);
        print(result['link']);
        print(result.data());
       });
      setState(() {
        print('value is');
        print(itemList.length);
      });
    });
  }
  Future<void> takeImage() async {
    await _picker.getImage(source: ImageSource.gallery).then((img) {
      image=File(img.path);
    });
    Reference storageReference = FirebaseStorage.instance.ref().child('new/${basename(image.path)}');
    UploadTask uploadTask=storageReference.putFile(image);
    var url=await(await uploadTask).ref.getDownloadURL();
    _uploadFileURL=url.toString();
      if(_uploadFileURL!=null)
      {
        dynamic key=CreateCryptoRandomString(32);
        _firestore..collection('MyImages').doc(key).set({
          'id':key,
          'link':_uploadFileURL,
        }).then((value) {
          ShowToastNow();
        });
      }else{
        print('url is null');
      }
    }

ShowToastNow(){
  Fluttertoast.showToast(msg: "Image Saved",toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
}
}