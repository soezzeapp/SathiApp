import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sathiclub/messages/chat/widgets/video_player_item.dart';

import '../../../common/enum/message_enum.dart';
import '../../../constants/themeColors.dart';


class DisplayTextImageGIF extends StatelessWidget {
  final bool myMessage;
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({Key? key,
    required this.myMessage,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return  type==MessageEnum.text?
    Text(message, style: TextStyle(fontSize: 16,color:myMessage?textColorMyMessage:
        textColorYourMessage
    ),):
    type==MessageEnum.image?
    CachedNetworkImage(imageUrl: message,
        placeholder: (context, url) => const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(messageColor))
    ):
    type==MessageEnum.video?
    VideoPlayerItem(videoUrl:message):
    type==MessageEnum.audio?
    StatefulBuilder(
        builder: (context,setState) {
          return IconButton(
              constraints: const BoxConstraints(
                  minWidth: 200
              ),
              onPressed:()async{
                if(isPlaying){
                  await audioPlayer.pause();
                  setState((){
                    isPlaying = false;
                  });
                }else{
                  await audioPlayer.play(UrlSource(message));
                  setState((){
                    isPlaying = true;
                  });
                }
              },icon:Icon(isPlaying?Icons.pause_circle:Icons.play_circle));
        }
    )
        :type==MessageEnum.gif?
    CachedNetworkImage(
        imageUrl: message,
        placeholder: (context, url) => const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(messageColor))
    ):Container();


  }
}
