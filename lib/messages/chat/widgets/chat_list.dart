import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sathiclub/messages/chat/bloc/chat_bloc.dart';
import 'package:sathiclub/messages/chat/widgets/sender_message_card.dart';
import 'package:sathiclub/messages/models/message.dart';
import 'package:sathiclub/messages/models/message_reply.dart';

import '../../../common/enum/message_enum.dart';
import '../bloc/message_reply_bloc/message_reply_bloc.dart';
import 'my_message_card.dart';


class ChatList extends StatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ChatList({Key? key,required this.receiverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();

  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum,
      ){
    /*ref.read(messageReplyProvider.state).update((state)=>
        MessageReply(
            message, isMe, messageEnum));*/
    BlocProvider.of<MessageReplyBloc>(context).add(ActivateMessageReplyEvent(
        messageReply: MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum)));
  }



  @override
  void dispose(){
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(widget.isGroupChat) {
      BlocProvider.of<ChatBloc>(context).add(WatchGroupChatsEvent(receiverUserId:widget.receiverUserId));
    }else{
      BlocProvider.of<ChatBloc>(context).add(WatchChatsEvent(receiverUserId:widget.receiverUserId));
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return StreamBuilder<List<Message>>(
        stream:widget.isGroupChat?
        ref.read(chatControllerProvider).groupChatStream(widget.receiverUserId)
        :
        ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Loader();
          }
          else{
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageController.jumpTo(messageController.position.maxScrollExtent);
            });*/
            return BlocBuilder<ChatBloc,ChatState>(
              builder: (context,state) {
                if(state is LoadingChatState){
                  return const Center(
                      child: CircularProgressIndicator());
                }
                else if(state is LoadedChatState){
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    messageController.jumpTo(messageController.position.maxScrollExtent);
                  });
                  return ListView.builder(
                    controller: messageController,
                    itemCount:state.chats.length,
                     //snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final messageData = state.chats[index];
                      //snapshot.data![index];
                      var timeSent = DateFormat.Hm().format(messageData.timeSent);
                      if(!messageData.isSeen && messageData.receiverId==FirebaseAuth.instance.currentUser!.uid){
                        BlocProvider.of<ChatBloc>(context).add(SetChatMessageSeen(context: context, receiverUserId: widget.receiverUserId, messageId: messageData.messageId));
                      //ref.read(chatControllerProvider).setChatMessageSeen(context, widget.receiverUserId, messageData.messageId);
                    }
                      if (messageData.senderId==FirebaseAuth.instance.currentUser!.uid) {
                        return MyMessageCard(
                          type: messageData.type,
                          message: messageData.text,
                          date: timeSent,
                          repliedText: messageData.repliedMessage,
                          userName: messageData.repliedTo,
                          repliedMessageType: messageData.repliedMessageType,
                          onLeftSwipe: ()=>onMessageSwipe(
                              messageData.text,
                              true,
                              messageData.type
                          ),
                          isSeen:messageData.isSeen,
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(widget.isGroupChat)
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(messageData.senderName,style: const TextStyle(
                                    color: Colors.grey),),
                              ),
                            ),
                          SenderMessageCard(
                            type: messageData.type,
                            message: messageData.text,
                            date: timeSent,
                            repliedText: messageData.repliedMessage,
                            userName: messageData.repliedTo,
                            repliedMessageType: messageData.repliedMessageType,
                            onRightSwipe: ()=>onMessageSwipe(
                                messageData.text,
                                false,
                                messageData.type
                            ),
                          ),
                        ],
                      );
                    },
                  );

                }else{
                  return Container();
                }

              }
            );
          }
        }
   // );
 // }
//}



