import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'full_screen_video_player_widget.dart';

class LandscapePlayerWidget extends StatefulWidget {
  final String mVideo;
  const LandscapePlayerWidget({Key? key,required this.mVideo}) : super(key: key);

  @override
  _LandscapePlayerWidgetState createState() => _LandscapePlayerWidgetState();
}

class _LandscapePlayerWidgetState extends State<LandscapePlayerWidget> {
  late VideoPlayerController controller;
  @override void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.mVideo)
      ..addListener(()=>setState((){}))
      ..setLooping(true)
      ..initialize().then((_)=>controller.play());
    setLandscape();
  }
  @override
  void dispose() {
    controller.dispose();
    setAllOrientations();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FullScreenVideoPlayerWidget(controller:controller);
  }

  Future setLandscape()async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //await Wakelock.enable();
  }
  Future setAllOrientations()async{
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top]);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //await Wakelock.disable();
  }


}
