
import 'dart:io';
import 'package:flutter/material.dart';

import 'common/widgets/error_screen.dart';
import 'messages/chat/screens/mobile_chat_screen.dart';
import 'messages/chat/widgets/debounce_canvas.dart';
import 'messages/group/screens/create_group_screen.dart';

Route<dynamic>generateRoute(RouteSettings settings){
  switch(settings.name){
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['id'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(builder:(context)=>MobileChatScreen(
        uid: uid,
        name: name,
        isGroupChat:isGroupChat ,
        profilePic: profilePic,
      ));

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder:(context)=>CreateGroupScreen());
    case MyCanvas.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final senderUser = arguments['senderUser'];
      final receiverUserId = arguments['receiverUserId'];
      final isGroupChat = arguments['isGroupChat'];
      return MaterialPageRoute(builder:(context)=>
          MyCanvas(receiverUserId: receiverUserId,isGroupChat: isGroupChat,senderUser:senderUser));
    default:
      return MaterialPageRoute(builder:(context)=>const Scaffold(
        body:ErrorScreen(error: 'This Page does not  exist',) ,
      ));
  }

}