import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/authentication/common/defaultUserModel.dart';
import 'package:sathiclub/authentication/models/UserModel.dart';
import 'package:sathiclub/messages/chat/bloc/chat_bloc.dart';
import 'package:sathiclub/messages/chat/bloc/message_reply_bloc/message_reply_bloc.dart';
import 'package:sathiclub/messages/models/message_reply.dart';
import '../../../common/enum/message_enum.dart';
import '../../../constants/themeColors.dart';
import '../../utils/utils.dart';
import 'debounce_canvas.dart';
import 'message_reply_preview.dart';




class BottomChatField extends StatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  final bool showPhoto;
  const BottomChatField({Key? key,
    required this.receiverUserId,
    required this.isGroupChat,
    required this.showPhoto,
  }) : super(key: key);

  @override
_BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  TextEditingController messageController = TextEditingController();
  bool isShowEmojiContainer = false ;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  UserModel senderUser = DefaultUser.defaultUser;
  MessageReply messageReply = MessageReply(
      message: '',
      isMe: true,
      messageEnum: MessageEnum.text);
  bool boolMessageReplyOn = false;
  void sendTextMessage(
      )async{
    if(isShowSendButton){
      /*ref.read(chatControllerProvider).sendTextMessage(
          context,
          messageController.text.trim(),
          widget.receiverUserId,
          widget.isGroupChat
      );*/
      if(widget.isGroupChat){
        BlocProvider.of<ChatBloc>(context).add(SendTextMessageGroup(
          context: context,
          text: messageController.text.trim(),
          senderUser:senderUser,
          receiverUserId:widget.receiverUserId,
          messageReply: messageReply,
        ));

      }else{
        BlocProvider.of<ChatBloc>(context).add(SendTextMessage(
          context: context,
          text: messageController.text.trim(),
          senderUser:senderUser,
          receiverUserId:widget.receiverUserId,
          messageReply: messageReply,
        ));

      }

      setState(() {
        messageController.text ='';
      });
      if(boolMessageReplyOn==true){turnOffReply();}
    }else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if(!isRecorderInit){
        return ;
      }
      if(isRecording){
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      }else{
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }

  }

  void selectImage() async{
    File ? image = await pickImageFromGallery(context);
    if(image!=null){
      sendFileMessage(image, MessageEnum.image);
    }
  }

 void sendFileMessage(File file, MessageEnum messageEnum,){
    /*ref.read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum, widget.isGroupChat);*/
  if(widget.isGroupChat) {
    BlocProvider.of<ChatBloc>(context).add(
        SendFileMessageGroup(context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          senderUser:senderUser,
          messageEnum: messageEnum,
          messageReply: messageReply,
        ));

  }else{
    BlocProvider.of<ChatBloc>(context).add(
        SendFileMessage(context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          senderUser:senderUser,
          messageEnum: messageEnum,
          messageReply: messageReply,
        ));

   }
  if(boolMessageReplyOn==true){turnOffReply();}
  }

  void selectVideo() async{
    File ? video = await pickVideoFromGallery(context);
    if(video!=null){
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer(){
    setState(() {
      isShowEmojiContainer = true;
    });
  }
  void toggleEmojiKeyboardContainer(){
    if(isShowEmojiContainer){
      showKeyBoard();
      hideEmojiContainer();
    }
    else{
      showEmojiContainer();
      hideKeyBoard();
    }
  }
  void showKeyBoard()=>focusNode.requestFocus();
  void hideKeyBoard()=>focusNode.unfocus();


  void selectGIF() async{
    final gif = await pickGIF(context);
    if(gif!=null){
      sendGifMessage(gif.url);
      /*ref.read(chatControllerProvider).sendGIFMessage(
          context, gif.url, widget.receiverUserId, widget.isGroupChat);*/
    }
  }
  void sendGifMessage(String gifUrl,){
    /*ref.read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum, widget.isGroupChat);*/
    if(widget.isGroupChat){
      BlocProvider.of<ChatBloc>(context).add(
          SendGifMessageGroup(context: context,
            gifUrl: gifUrl,
            receiverUserId: widget.receiverUserId,
            senderUser:senderUser,
            messageReply: messageReply,
          ));

    }else{
      BlocProvider.of<ChatBloc>(context).add(
          SendGifMessage(context: context,
            gifUrl: gifUrl,
            receiverUserId: widget.receiverUserId,
            senderUser:senderUser,
            messageReply: messageReply,
          ));
      if(boolMessageReplyOn==true){turnOffReply();}

    }
  }

  void turnOffReply(){
      setState(() {
        boolMessageReplyOn = false;
      });
      BlocProvider.of<MessageReplyBloc>(context).
      add(CancelMessageReplyEvent());
  }

  void openAudio()async{
    final status = await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;

  }

  @override
  void initState(){
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose(){
    super.dispose();
    messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    //final messageReply = ref.watch(messageReplyProvider);
    //final isShowMessageReply = messageReply!=null;
        return BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,state) {
            if(state is AuthenticatedState){
              senderUser = state.user;
              return Column(
                children: [
                  //isShowMessageReply?const MessageReplyPreview():const SizedBox(),
                  BlocConsumer<MessageReplyBloc,MessageReplyState>(
                    listener: (context,state){
                      if(state is LoadedMessageReplyState){
                        messageReply = state.messageReply;
                        boolMessageReplyOn = true;
                      }
                      else{
                        messageReply = MessageReply(
                            message: '',
                            isMe: true,
                            messageEnum: MessageEnum.text);
                      }
                    },
                    builder: (context,event) {
                      return const MessageReplyPreview();
                    }
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color:textColorChatBox),
                          onTap:(){
                            hideEmojiContainer();
                          },
                          controller: messageController,
                          focusNode: focusNode,
                          onChanged: (val){
                            if(val.isNotEmpty){
                              setState(() {
                                isShowSendButton= true;
                              });
                            }
                            else{
                              setState(() {
                                isShowSendButton= false;
                              });

                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: mobileChatBoxColor,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: SizedBox(
                                width:100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        padding:EdgeInsets.zero,
                                        onPressed: (){
                                          toggleEmojiKeyboardContainer();
                                        },
                                        icon: Icon(Icons.emoji_emotions,
                                          color: widget.showPhoto?Colors.grey:Colors.black,)),
                                    GestureDetector(
                                      onTap: (){
                                        selectGIF();
                                      },
                                      child: SizedBox(
                                          width: 20,
                                          child: Icon(Icons.gif,
                                            color: widget.showPhoto?Colors.grey:Colors.black,)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            suffixIcon: SizedBox(
                              width:120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                        onPressed: (){
                                          Navigator.pushNamed(context, MyCanvas.routeName,
                                            arguments:{
                                              'senderUser':senderUser,
                                              'receiverUserId':widget.receiverUserId,
                                              'isGroupChat':widget.isGroupChat,
                                            }
                                        );

                                        },
                                        icon: Icon(Icons.photo,
                                          color:widget.showPhoto?Colors.grey:Colors.black)),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      //padding:const EdgeInsets.only(right: 16),
                                        onPressed: (){
                                          selectImage();
                                        },
                                        icon: Icon(Icons.camera_alt,
                                          color: widget.showPhoto?Colors.grey:Colors.black,)),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: IconButton(
                                      //padding:const EdgeInsets.only(right: 24),
                                        onPressed: (){
                                          selectVideo();
                                        },
                                        icon: Icon(Icons.video_camera_front,
                                          color: widget.showPhoto?Colors.grey:Colors.black,)),
                                  ),
                                ],
                              ),
                            ),
                            hintText: 'Type a message!',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8,right: 2,left: 2),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: themeButtonColor,
                            child:GestureDetector(
                                onTap: (){
                                 sendTextMessage();
                                },
                                child: Icon(isShowSendButton? Icons.send
                                    : isRecording?Icons.close:Icons.keyboard_voice,color: Colors.white,))
                        ),
                      )
                    ],
                  ),
                  isShowEmojiContainer?
                  SizedBox(
                      height: 310,
                      child:EmojiPicker(
                      onEmojiSelected: ((category,emoji){
                        setState(() {
                          messageController.text = messageController.text+emoji.emoji;
                        });
                        if(!isShowSendButton){
                          setState(() {
                            isShowSendButton = true;
                          });
                        }
                      }),
                    )
                  ):Container(),
                ],
              );
            } else{
              return Container();
            }

          }
        );

  }
}
