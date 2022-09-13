import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sathiclub/common/widgets/video_player_both_widget.dart';
import 'package:video_player/video_player.dart';

import 'full_screen_video_player_widget.dart';

class PortraitLandscapePlayerWidget extends StatefulWidget {
  final String mVideo;
  const PortraitLandscapePlayerWidget({Key? key,required this.mVideo}) : super(key: key);

  @override
  _PortraitLandscapePlayerWidgetState createState() => _PortraitLandscapePlayerWidgetState();
}

class _PortraitLandscapePlayerWidgetState extends State<PortraitLandscapePlayerWidget> {
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
    return Scaffold(
        backgroundColor: Colors.black,
        body: VideoPlayerBothWidget(controller:controller));
  }

}
