import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lets_connect/model/user_data.dart';
import 'package:lets_connect/services/firestore_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CanvasDraw extends StatefulWidget {
  final chatRoom;
  final collectionName;
  CanvasDraw({@required this.chatRoom, @required this.collectionName});
  @override
  _CanvasDrawState createState() => _CanvasDrawState();
}

class _CanvasDrawState extends State<CanvasDraw> {
  var isLoading = false;
  String createCryptoRandomString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  GlobalKey globalKey = GlobalKey();
  ui.PictureRecorder _recorder;
  Canvas _canvas;
  Image img;
  Size availableSize;
  final dpr = ui.window.devicePixelRatio;
  List<DrawModel> points = [];
  Color color = Colors.black;
  String _uploadFileURL;
  @override
  Widget build(BuildContext context) {
    availableSize = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                    Text('Sending Doodle')
                  ])
            : Container(
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      RenderBox object = context.findRenderObject();
                      points.add(DrawModel(
                        offset: object.globalToLocal(details.globalPosition),
                        paint: Paint()
                          ..color = color
                          ..strokeCap = StrokeCap.round
                          ..strokeWidth = 5.0,
                      ));
                      // Offset _localPosition = object.globalToLocal(details.globalPosition);
                      // _points=new List.from(_points)..add(_localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) => points.add(null),
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/canvas.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        CustomPaint(
                            painter: new ImagePainter(pointsList: points),
                            size: Size.infinite),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_arrow,
          children: [
            SpeedDialChild(
              child: Icon(Icons.save, color: Colors.white),
              backgroundColor: Colors.grey,
              label: "Send Doodle",
              onTap: () {
                setState(() {
                  //generateImage();
                  _saveImage();
                });
              },
            ),
            SpeedDialChild(
                child: Icon(Icons.replay_outlined, color: Colors.white),
                backgroundColor: Colors.grey,
                label: "Reset Draw",
                onTap: () {
                  setState(() {
                    points.clear();
                  });
                }),
            SpeedDialChild(
              child: Icon(MdiIcons.card, color: Colors.white),
              backgroundColor: Colors.grey,
              label: "Eraser",
              onTap: () => color = Colors.white,
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.pen, color: Colors.white),
              backgroundColor: Colors.black,
              label: "Black Pen",
              onTap: () => color = Colors.black,
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.pen, color: Colors.white),
              backgroundColor: Colors.red,
              label: "Red Pen",
              onTap: () => color = Colors.red,
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            child:Icon(Icons.send,color:Colors.white),
            backgroundColor: Colors.grey,
            label:"Send Doodle",
            onTap: (){
              setState(() {
                _sendImage();
              });
            },
          ),
          SpeedDialChild(
            child:Icon(Icons.save,color:Colors.white),
            backgroundColor: Colors.grey,
            label:"Save Doodle",
            onTap: (){
              setState((){
              _saveImage();
              });
            }
          ),
          SpeedDialChild(
            child:Icon(Icons.replay_outlined,color:Colors.white),
            backgroundColor: Colors.grey,
            label:"Reset Draw",
            onTap: (){
              setState((){
              points.clear();
              });
            }
          ),
          SpeedDialChild(
            child:Icon(MdiIcons.card,color:Colors.white),
            backgroundColor: Colors.grey,
            label:"Eraser",
            onTap: ()=>color=Colors.white,
          ),
          SpeedDialChild(
            child:Icon(MdiIcons.pen,color:Colors.white),
            backgroundColor: Colors.black,
            label:"Black Pen",
            onTap: ()=>color=Colors.black,
          ),
          SpeedDialChild(
            child:Icon(MdiIcons.pen,color:Colors.white),
            backgroundColor: Colors.red,
            label:"Red Pen",
            onTap: ()=>color=Colors.red,
          ),
          SpeedDialChild(
            child:Icon(MdiIcons.pen,color:Colors.white),
            backgroundColor: Colors.blue,
            label:"Blue Pen",
            onTap: ()=>color=Colors.blue,
          ),
          SpeedDialChild(
            child:Icon(MdiIcons.pen,color:Colors.white),
            backgroundColor: Colors.green,
            label:"Green Pen",
            onTap: ()=>color=Colors.green,
          ),
        ],
      )
      
    );
  }

  void initializeRecording() {
    _recorder = ui.PictureRecorder();
    _canvas = Canvas(_recorder);
    _canvas.scale(dpr, dpr);
  }

  @override
  void initState() {
    super.initState();
    initializeRecording();
  }

  Future<void> _saveImage() async {
    setState(() {
      isLoading = true;
    });
    dynamic key = createCryptoRandomString(32);
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    print(image);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print(byteData);
    Uint8List pngByte = byteData.buffer.asUint8List();
    print(pngByte);

    if(!(await Permission.storage.status.isGranted))
    {
      await Permission.storage.request();
    }

    final result=await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngByte),
      quality: 50,
      name:"canvas_image_${key}"
    );
    print(result);
  }

  Future<void> _sendImage() async{
    dynamic key = CreateCryptoRandomString(32);
    RenderRepaintBoundary boundary= globalKey.currentContext.findRenderObject();
    ui.Image image=await boundary.toImage();
    print(image);
    ByteData byteData=await image.toByteData(format:ui.ImageByteFormat.png);
    print(byteData);
    Uint8List pngByte=byteData.buffer.asUint8List();
    print(pngByte);
    Uint8List finalImage=Uint8List.view(pngByte.buffer);
    final Directory systemTempDir=Directory.systemTemp;
    final File file = await new File('${systemTempDir.path}/foo.png').create();
    file.writeAsBytes(finalImage);
    final Reference ref=FirebaseStorage.instance.ref().child('Doodle_Images').child('image${key}.png');
    final UploadTask uploadTask=ref.putFile(file);
    var url = await (await uploadTask).ref.getDownloadURL();
    _uploadFileURL = url.toString();
    await sendMessage(_uploadFileURL);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  sendMessage(String url) async {
    try {
      FireStoreService.addConversationMessages(
          widget.collectionName, widget.chatRoom, {
        'message': url,
        'sentBy': Provider.of<UserData>(context, listen: false).userName,
        'createdAt': Timestamp.now(),
        'messageType': 'image'
      });
    } on FirebaseException catch (error) {
      print(error.message);
    }
  }
}

class ImagePainter extends CustomPainter {
  List<DrawModel> pointsList;
  Color color = Colors.black;
  ImagePainter({this.pointsList});
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].offset, pointsList[i + 1].offset,
            pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => true;
}

class DrawModel {
  final Offset offset;
  final Paint paint;
  DrawModel({this.offset, this.paint});
}
