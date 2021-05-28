import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_connect/model/user_data.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  static final _firestore = FirebaseFirestore.instance;
  final fb = FirebaseDatabase.instance.reference().child('MyImages');
  final ImagePicker _picker = ImagePicker();
  List<dynamic> itemList = new List();
  List<String> imageList = new List();
  List<dynamic> list = new List();
 // List<dynamic> storeDate = new List();
  List<dynamic> storeTime = new List();
 // List<dynamic> date=new List();
  List<dynamic> time=new List();
  List<dynamic> ans=new List();
  List<String> userList = new List();
  var now=DateTime.now();
  File image;
  String _uploadFileURL;
  String name;
  final StoryController controller = StoryController();
  String CreateCryptoRandomString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget LoadImage() {
      print(imageList.length);
      return Expanded(
          child: imageList.length == 0
              ? Text("Loading")
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Container(
                            height: 60,
                            width: 60,
                            child: GestureDetector(
                              onTap: () async {
                                await _firestore
                                    .collection('MImages')
                                    .get()
                                    .then((querySnapshot) {
                                  querySnapshot.docs.forEach((result) {
                                    if (result['id'] == userList[index]) {
                                      print('yess');
                                      name = userList[index];
                                      itemList = result['url'];
                                      time=result['time'];
                                    }
                                  });
                                  setState(() {
                                    print('value is');
                                    ans.clear();
                                    for(int i=0;i<itemList.length;i++){
                                          print(itemList[i]);
                                          print(time[i]);
                                          show(itemList[i],name,time[i]);
                                    }
                                    print(itemList.length);
                                    print(imageList.length);
                                  });
                                });
                                print("pppppppppppppppppppppppppppppp");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.purple,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imageList[index]),
                                  ),
                                ),
                                // child: Padding(
                                //   padding: const EdgeInsets.symmetric(vertical:8.0),
                                //   child: Text(
                                //     userList[index],
                                //     style: TextStyle(
                                //       fontFamily: "Arial Rounded",
                                //       fontSize: 12,
                                //     ),
                                //   ),
                                // ),
                              ),
                              
                            ),
                          ),
                        ),
                        //SizedBox(height: 2,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Container(
                            height: 15,
                            width: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    userList[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Arial Rounded",
                                      color: Colors.purple,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),   
                          ),
                        ),
                      ],
                    );
                  }));
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Container(
                height: 90,
                width: width,
                child: LoadImage(),
              ),
            ),
            ans.length == 0
                ? Text("Loading")
                : Expanded(
                    child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: height -290,
                        child: StoryView(
                          controller: controller,
                          storyItems: [
                            for (var i in ans) showl(i, name)
                            //for(int i=0;i<itemList.length;i++) show(itemList[i],name,date[i],time[i]),
                          ],
                          onStoryShow: (s) {
                            print("Showing a story");
                          },
                          onComplete: () {
                            print("Complete a cycle");
                          },
                          progressPosition: ProgressPosition.bottom,
                          repeat: true,
                          inline: true,
                        ),
                      ),
                    ],
                  ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takeImage(userData);
        },
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  show(String data, String name,String time)
  {
    print('why');
    print(time);
    Duration difference= now.difference(DateTime.tryParse(time));
    print(difference.inDays);
    if(difference.inDays==0)
    {
      ans.add(data);
    }
  }

  showl(String data, String name) {
    print('yesss00');
    return StoryItem.inlineImage(
      url: data,
      controller: controller,
      duration: Duration(seconds: 100),
      caption: Text(
        name == null ? 'User Profile' : '@$name',
        style: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
          backgroundColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  @override
  void initState() {
    _firestore.collection('MImages').get().then((querySnapshot) {
      itemList.clear();
      imageList.clear();
      querySnapshot.docs.forEach((result) {
        ans.add(result['userImage']);
        imageList.add(result['userImage']);
        userList.add(result['id']);
        time.add(result['currTime']);
        print(result['time']);
        print(result['link']);
        print(result['userImage']);
        print(result.data());
      });
      setState(() {
        print('value is');
        print(itemList.length);
        print(imageList.length);
      });
    });
  }

  Future<void> takeImage(UserData userData) async {
    await _picker.getImage(source: ImageSource.gallery).then((img) {
      image = File(img.path);
    });
    Reference storageReference =
        FirebaseStorage.instance.ref().child('new/${basename(image.path)}');
    UploadTask uploadTask = storageReference.putFile(image);
    var url = await (await uploadTask).ref.getDownloadURL();
    _uploadFileURL = url.toString();
    if (_uploadFileURL != null) {
      dynamic key = CreateCryptoRandomString(32);
      final documentSnapshot =
          await _firestore.collection('MImages').doc(userData.userName).get();
      if (documentSnapshot.exists == true) {
        print('yesss');
        await _firestore.collection('MImages').get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            if (result['id'] == userData.userName) {
              print('yess');
              list = result['url'];
              storeTime=result['time'];
            }
          });
          setState(() {
            print('value is');
            print(itemList.length);
            print(imageList.length);
          });
        });
        list.add(_uploadFileURL);
        print('${now}');
        storeTime.add('${now}');
        print(storeTime);
        _firestore.collection('MImages').doc(userData.userName).update({
          'link':_uploadFileURL,
          'url': list,
          'userImage':userData.imageUrl,
          'currTime':'${now}',
          'time':storeTime,
        }).then((value) {
          ShowToastNow();
        });
      } else {
        list.add(_uploadFileURL);
        storeTime.add('${now}');
        print(storeTime);
        _firestore.collection('MImages').doc(userData.userName).set({
          'id': userData.userName,
          'userImage': userData.imageUrl,
          'url': list,
          'link': _uploadFileURL,
          'currTime':'${now}',
          'time':storeTime,
        }).then((value) {
          ShowToastNow();
        });
      }
    } else {
      print('url is null');
    }
  }
  

  ShowToastNow() {
    Fluttertoast.showToast(
        msg: "Status Uploaded",
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey[700],
        gravity: ToastGravity.BOTTOM);
  }
}

