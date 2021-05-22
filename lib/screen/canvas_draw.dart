import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui' as ui;
class CanvasDraw extends StatefulWidget {
  @override
  _CanvasDrawState createState() => _CanvasDrawState();
}

class _CanvasDrawState extends State<CanvasDraw> {
  GlobalKey globalKey = GlobalKey();
  ui.PictureRecorder _recorder;
  Canvas _canvas;
  Image img;
  Size availableSize;
  final dpr=ui.window.devicePixelRatio;
  List<DrawModel> points=List();
  Color color=Colors.black;
  String _imageFile;
  String _uploadFileURL;
  @override
  Widget build(BuildContext context) {

    availableSize=MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details){
            setState(() {
              RenderBox object= context.findRenderObject();
              points.add(DrawModel(offset:object.globalToLocal(details.globalPosition),
              paint: Paint()
              ..color=color
              ..strokeCap=StrokeCap.round
              ..strokeWidth=5.0,
              ));
              // Offset _localPosition = object.globalToLocal(details.globalPosition);
              // _points=new List.from(_points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details)=> points.add(null),
          child: RepaintBoundary(
              key: globalKey,
              child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration( 
                  image: DecorationImage( 
                    image:AssetImage('assets/images/canvas.png'),
                    fit:BoxFit.fill, 
                  ),
                  ),
                ),
                CustomPaint(painter: new ImagePainter(pointsList: points) ,size:Size.infinite),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
            child:Icon(Icons.save,color:Colors.white),
            backgroundColor: Colors.grey,
            label:"Send Doodle",
            onTap: (){
              setState(() {
                //generateImage();
                _saveImage();
              });
            },
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

  void initializeRecording(){
    _recorder=ui.PictureRecorder();
    _canvas= Canvas(_recorder);
    _canvas.scale(dpr,dpr);
  }

  @override
  void initState(){
    super.initState();
    initializeRecording();
  }

  Future<void> _saveImage() async{
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
    final Reference ref=FirebaseStorage.instance.ref().child('images').child('image.png');
    final UploadTask uploadTask=ref.putFile(file);
    var url = await (await uploadTask).ref.getDownloadURL();
    _uploadFileURL = url.toString();  
    print(_uploadFileURL);  
  }

  Future uploadPic(BuildContext context) async {
    try {
      String fileName = _imageFile.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putString(_imageFile);//putFile(_imageFile);
      var url = await (await uploadTask).ref.getDownloadURL();
      _uploadFileURL = url.toString();
      print(_uploadFileURL);
    } catch (error) {
      print('error');
    }
}
}

  


class ImagePainter extends CustomPainter{
  List<DrawModel>pointsList;
  Color color=Colors.black;
  ImagePainter({this.pointsList});
  @override
  void paint(Canvas canvas, Size size) {
    
    for(int i=0;i<pointsList.length-1;i++)
    {
      if(pointsList[i]!=null&&pointsList[i+1]!=null)
      {
        canvas.drawLine(pointsList[i].offset, pointsList[i+1].offset, pointsList[i].paint);
      }
    }
  }
  
    @override
    bool shouldRepaint(ImagePainter oldDelegate) =>true;

}

class DrawModel{
  final Offset offset;
  final Paint paint;
  DrawModel({this.offset,this.paint});
}