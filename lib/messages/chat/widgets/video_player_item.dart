import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sathiclub/common/widgets/portrait_video_player_widget.dart';

import '../../../common/widgets/potrait_landscape_video_player_widget.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;

  @override
  void initState(){
    super.initState();
    videoPlayerController =  CachedVideoPlayerController
        .network(widget.videoUrl)
        ..initialize()
          .then((value){
        videoPlayerController.setVolume(1) ;
      });
  }

  @override
  void dispose(){
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:16/9,
      child:Stack(
        children: [
          GestureDetector(
              onTap: (){
                videoPlayerController.dispose();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PortraitLandscapePlayerWidget(mVideo:widget.videoUrl))).then((value){
                   videoPlayerController =  CachedVideoPlayerController
                      .network(widget.videoUrl)
                    ..initialize();
                  setState(() {});
                });
            },
              child: CachedVideoPlayer(videoPlayerController)),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: (){
                  if(isPlaying){
                    videoPlayerController.pause();
                  }
                  else{
                    videoPlayerController.play();
                  }
                  setState(() {
                    isPlaying=!isPlaying;
                  });
                },
                icon:isPlaying?const Icon(Icons.pause_circle): const Icon(Icons.play_circle)),
          )
        ],

      ),
    );
  }
}
