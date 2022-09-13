import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'full_screen_video_player_widget.dart';

class PortraitPlayerWidget extends StatefulWidget {
  final String mVideo;
  const PortraitPlayerWidget({Key? key,required this.mVideo}) : super(key: key);

  @override
  _PortraitPlayerWidgetState createState() => _PortraitPlayerWidgetState();
}

class _PortraitPlayerWidgetState extends State<PortraitPlayerWidget> {
  late VideoPlayerController controller;
  @override void initState() {
    super.initState();
  controller = VideoPlayerController.network(widget.mVideo)
    ..addListener(()=>setState((){}))
    ..setLooping(true)
    ..initialize().then((_)=>controller.play());
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FullScreenVideoPlayerWidget(controller:controller);
  }



}
