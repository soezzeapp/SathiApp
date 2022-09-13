
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui'as ui;
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:sathiclub/authentication/models/UserModel.dart';

import '../../../common/enum/message_enum.dart';
import '../../models/message_reply.dart';
import '../bloc/chat_bloc.dart';

class MyCanvas extends StatefulWidget {
  static const String routeName = '/canvas-screen';
  final UserModel senderUser;
  final String receiverUserId;
  final bool isGroupChat;
  const MyCanvas({Key? key,
    required this.senderUser,
    required this.receiverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  _MyCanvasState createState() => _MyCanvasState();
}

class DrawingArea{
  Offset point;
  Paint areaPaint;
  DrawingArea({required this.point, required this.areaPaint});

}

class _MyCanvasState extends State<MyCanvas> {
  List<DrawingArea ?> points =[];
  Color selectedColor = Colors.black;
  double strokeWidth=20;
  GlobalKey globalKey = GlobalKey();
  @override
  void initState(){
    super.initState();
    selectedColor = Colors.black;
    strokeWidth=2.0;
  }
  void selectColor() {
    final double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(8.0),
          content: SingleChildScrollView(
            child: Container(
              height: screenHeight/2,
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color){
                  this.setState(() {
                    selectedColor= color;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> sendImageMessage(Uint8List dataImage, MessageEnum messageEnum,)async{
    bool success = false;
    try{
      /*ref.read(chatControllerProvider)
          .sendImageMessage(context, dataImage, widget.receiverUserId, messageEnum, widget.isGroupChat);*/
      if(widget.isGroupChat){
        BlocProvider.of<ChatBloc>(context).add(
            SendDataImageMessageGroup(context: context,
              dataImage: dataImage,
              receiverUserId: widget.receiverUserId,
              senderUser:widget.senderUser,
              messageEnum: messageEnum,
              messageReply: MessageReply(
                  message: '', isMe: true, messageEnum:MessageEnum.text),
            ));
      }else{
        BlocProvider.of<ChatBloc>(context).add(
            SendDataImageMessage(context: context,
              dataImage: dataImage,
              receiverUserId: widget.receiverUserId,
              senderUser:widget.senderUser,
              messageEnum: messageEnum,
              messageReply: MessageReply(
                  message: '', isMe: true, messageEnum:MessageEnum.text),
            ));
      }
      success= true;
    }catch(e){
      success= false;
    }
    return success;
  }
  Future<void>_save()async{

    RenderRepaintBoundary ? boundary = globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes= byteData!.buffer.asUint8List();
    /*
    if(!(await Permission.storage.status.isGranted)){
      await Permission.storage.request();
    }
    final response  = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      quality:60,
      name:'canvas_image',
    );*/
    sendImageMessage(pngBytes, MessageEnum.image).then((_) => Navigator.of(context).pop());
  }
  @override

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: SizedBox(
        height:50,
        width:50,
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          onPressed: (){Navigator.of(context).pop();},
          child: const Icon(Icons.apps,size:42),
        ),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
      body: RepaintBoundary(
        key: globalKey,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget> [
                  Container(
                    width: screenWidth*.90,
                    height: screenHeight*.80,
                    decoration: BoxDecoration(
                      //border:Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color:Colors.black.withOpacity(0.4),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      //image:DecorationImage(image:AssetImage('assets/ca.png'), fit: BoxFit.fill),
                    ),
                    child: GestureDetector(
                      onPanDown:(details) {
                        setState(() {
                          points.add(DrawingArea(
                              point:details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth
                          ));
                        });
                      },
                      onPanUpdate:(details) {
                        setState(() {
                          points.add(DrawingArea(
                              point:details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth
                          ));
                        });

                      },
                      onPanEnd:(details) {
                        points.add(null);
                      },
                      child:ClipRRect(
                        borderRadius:const BorderRadius.all(Radius.circular(20.0)),
                        child: SingleTouchRecognizerWidget(
                          child: CustomPaint(
                            painter:MyCustomPainter(points:points,color:selectedColor,strokeWidth: strokeWidth),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height:10),
                  Container(
                    width:screenWidth*.90,
                    decoration:const BoxDecoration(
                      color:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child:Row(
                      children:<Widget>[
                        //IconButton(icon:Icon(Icons.color_lens,color:selectedColor),onPressed: (){
                        //selectColor();
                        //},),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(48,8,0,8),
                          child: GestureDetector(
                            child:SizedBox(
                                height:screenHeight/20,
                                width: screenWidth/10,
                                child:const Icon(Icons.album,size: 48,)
                            ),
                            onTap: (){this.setState(() {selectedColor = Colors.white;});},),
                        ),
                        Expanded(child: Slider(
                          min:1.0, max:50.0, activeColor: selectedColor,
                          value:strokeWidth,
                          onChanged:(value) { this.setState(() { strokeWidth = value;});},)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,8,0,8),
                          child: GestureDetector(
                            child:SizedBox(
                                height:screenHeight/15,
                                width: screenWidth/8,
                                child:Icon(Icons.color_lens_outlined,size: 48,color: selectedColor,)
                            ),
                            onTap: (){selectColor();},),
                        ),



                        //IconButton(icon:Icon(Icons.crop_square,color:selectedColor),onPressed: (){
                        //this.setState(() {selectedColor =Colors.white;});},),


                        //IconButton(icon:Icon(Icons.layers_clear),onPressed: (){this.setState(() {points.clear();});},),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8,8,0,8),
                          child: GestureDetector(
                            child:SizedBox(
                                height:screenHeight/20,
                                width: screenWidth/10,
                                child:Icon(Icons.description,size: 48,color: selectedColor,)
                            ),
                            onTap: (){this.setState(() {points.clear();});},),
                        ),
                        //IconButton(icon:Icon(Icons.save),onPressed: (){_save();},),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24,8,8,8),
                          child: GestureDetector(
                            child:SizedBox(
                                height:screenHeight/20,
                                width: screenWidth/10,
                                child:const Icon(Icons.send,size: 48,color: Colors.black,)
                            ),
                            onTap: (){this.setState(() {_save();});},),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}


class MyCustomPainter extends CustomPainter{
  List<DrawingArea?> points;
  Color color;
  double strokeWidth;
  MyCustomPainter({required this.points,required this.color,required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {

    Paint background =Paint()..color=Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect,background);

    for(int x=0;x<points.length-1;x++){
      if(points[x]!=null && points[x+1]!=null){
        Paint paint = points[x]!.areaPaint;
        canvas.drawLine(points[x]!.point, points[x+1]!.point, paint);
        //print(points.length);
      }
      else if(points[x]!=null&&points[x+1]==null){
        Paint paint = points[x]!.areaPaint;
        canvas.drawPoints(ui.PointMode.points,[points[x]!.point] ,paint);
        //print(points.length);
      }
    }
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class SingleTouchRecognizerWidget extends StatelessWidget {
  final Widget child;
  SingleTouchRecognizerWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _SingleTouchRecognizer: GestureRecognizerFactoryWithHandlers<_SingleTouchRecognizer>(
              () => _SingleTouchRecognizer(),
              (_SingleTouchRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}

class _SingleTouchRecognizer extends OneSequenceGestureRecognizer {

  int _p = 0;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    //first register the current pointer so that related events will be handled by this recognizer
    startTrackingPointer(event.pointer);
    //ignore event if another event is already in progress
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  // TODO: implement debugDescription
  String get debugDescription => 'default';

  @override
  void didStopTrackingLastPointer(int pointer) {
    // TODO: implement didStopTrackingLastPointer
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}





