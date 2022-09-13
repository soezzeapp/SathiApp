import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message_reply_bloc/message_reply_bloc.dart';
import 'display_text_image_gif.dart';


class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  /*void cancelReply(WidgetRef ref){
    ref.read(messageReplyProvider.state).update((state)=>null);
  }*/

  @override
  Widget build(BuildContext context,) {
    //final messageReply = ref.watch(messageReplyProvider);
    return BlocBuilder<MessageReplyBloc,MessageReplyState>(
      builder: (context,state) {
        if(state is LoadedMessageReplyState){
          final messageReply = state.messageReply;
          return Container(
              width: 350,
              padding:const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
              ),
              child:Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:Text(
                          messageReply.isMe?'Me':'Opposite',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                          child: const Icon(Icons.close,size: 21,),
                          //onTap:()=> cancelReply(ref)
                         onTap:(){
                           BlocProvider.of<MessageReplyBloc>(context).
                           add(CancelMessageReplyEvent());
                         }
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 200,
                      child:DisplayTextImageGIF(
                        myMessage: false,
                        message: messageReply.message,
                        type: messageReply.messageEnum,
                      )
                  )
                ],

              )
          );
        }else {
          return const SizedBox();
        }

      }
    );
  }
}
