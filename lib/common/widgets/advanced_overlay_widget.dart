import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants/constants.dart';

class AdvanceOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;

  const AdvanceOverlayWidget({Key? key,
    required this.controller,
    required this.onClickedFullScreen,
  }) : super(key: key);

  @override
  State<AdvanceOverlayWidget> createState() => _AdvanceOverlayWidgetState();
}

class _AdvanceOverlayWidgetState extends State<AdvanceOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:()=>widget.controller.value.isPlaying?widget.controller.pause():widget.controller.play(),
      child: Stack(
        children: [
          buildPlay(),
          buildSpeed(),
          buildCancel(),
          Positioned(
            left:8,
            bottom: 28,
            child:Text(getPosition(),style: TextStyle(decoration: TextDecoration.none,color: Colors.white,fontSize: 18),)
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(child: buildIndicator()),
                  const SizedBox(width:12),
                  GestureDetector(
                    onTap: (){ widget.onClickedFullScreen;},
                    child:Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size:28,
                    )
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget buildIndicator()=>VideoProgressIndicator(
      widget.controller, allowScrubbing: true);

  Widget buildPlay()=>widget.controller.value.isPlaying?Container():Icon(Icons.play_arrow,color: Colors.grey,);

  String getPosition(){
    final duration = Duration (
      milliseconds: widget.controller.value.position.inMilliseconds.round());
    return [duration.inMinutes,duration.inSeconds]
        .map((seg)=>seg.remainder(60).toString().padLeft(2,'0'))
        .join(':');
  }

  Widget buildSpeed()=>Align(
      alignment: Alignment.topLeft,
      child: PopupMenuButton<double>(
        initialValue: widget.controller.value.playbackSpeed,
        tooltip: 'Playback speed',
        onSelected: widget.controller.setPlaybackSpeed,
        itemBuilder:(context)=> Constants.allSpeeds
        .map<PopupMenuEntry<double>>((speed)=>PopupMenuItem(
            value:speed,
            child: Text('${speed}x'))).toList(),
        child:Container(
          color:Colors.white30,
          padding:EdgeInsets.symmetric(vertical: 12,horizontal: 12),
          child:Text('${widget.controller.value.playbackSpeed}x')
        )
      ));

  Widget buildCancel()=>Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.cancel,color: Colors.grey,),
        onPressed: (){Navigator.of(context).pop();},
      ));
}
