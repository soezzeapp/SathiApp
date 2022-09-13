import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'advanced_overlay_widget.dart';
import 'basic_overlay_widget.dart';

class VideoPlayerBothWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerBothWidget ({Key? key,required this.controller}) : super(key: key);

  @override
  State<VideoPlayerBothWidget> createState() => _VideoPlayerBothWidgetState();
}

class _VideoPlayerBothWidgetState extends State<VideoPlayerBothWidget> {
  Orientation ?target;

  @override
  void initState(){
    super.initState();
    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor:true)
        .listen((event){
          final isPortrait = event == NativeDeviceOrientation.portraitUp;
          final isLandscape = event == NativeDeviceOrientation.landscapeLeft||
           event == NativeDeviceOrientation.landscapeLeft;
          final isTargetPortrait = target == Orientation.portrait;
          final isTargetLandscape = target == Orientation.landscape;
          if(isPortrait && isTargetPortrait ||isLandscape&&isTargetLandscape
          ){
            target = null;
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          }
    });
  }


  @override
  Widget build(BuildContext context) =>
      widget.controller!=null && widget.controller.value.isInitialized?
      Container(
          alignment: Alignment.topCenter,
          child: buildVideo()
      ):Center(child:CircularProgressIndicator(),);

  Widget buildVideo()=>OrientationBuilder(
    builder: (context,orientation) {
      final isPortrait = orientation ==Orientation.portrait;
      return Stack(
        fit:isPortrait?StackFit.loose:StackFit.expand,
        children: <Widget>[
          buildVideoPlayer(),
          //Positioned.fill(child:BasicOverlayWidget(controller:controller)),
          Positioned.fill(
            child:AdvanceOverlayWidget(
              controller:widget.controller,
              onClickedFullScreen:(){
                target = isPortrait?Orientation.landscape:Orientation.portrait;
                if(isPortrait){
                  AutoOrientation.landscapeRightMode();
                }else{
                  AutoOrientation.portraitUpMode();
                }
              }
            ),
          ),

        ],
      );
    }
  );

  Widget buildVideoPlayer()=>buildFullScreen(
    child: AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child:VideoPlayer(widget.controller),
    ),
  );

  Widget buildFullScreen({required Widget child}){
    final size = widget.controller.value.size;
    final width = size.width;
    final height = size.height;
    return FittedBox(
      fit:BoxFit.cover,
      //alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );

  }
}
