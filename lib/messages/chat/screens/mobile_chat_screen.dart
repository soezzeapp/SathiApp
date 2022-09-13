import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:sathiclub/authentication/models/UserModel.dart';
import 'package:sathiclub/messages/call/screens/call_pickup_screen.dart';
import 'package:sathiclub/messages/chat/bloc/receiver_user_bloc/receiver_user_bloc.dart';
import 'package:sathiclub/settings/chat_setting/chat_setting_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../authentication/common/defaultUserModel.dart';
import '../../../constants/themeColors.dart';
import '../../call/bloc/call_bloc.dart';
import '../../models/call.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';


class MobileChatScreen extends StatefulWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  MobileChatScreen({Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  UserModel senderUser = DefaultUser.defaultUser;
  UserModel contactUser = DefaultUser.defaultUser;
  bool showPhoto = false;

  void makeCall(BuildContext context){
    /*ref.read(callControllerProvider).makeCall(context, name, uid, profilePic, false);*/
    String callId = Uuid().v1();
    final senderCallData= Call(
        callerId: senderUser.id,
        callerName: senderUser.name,
        callerPic: senderUser.profileUrl,
        receiverId: contactUser.id,
        receiverName: contactUser.name,
        receiverPic: contactUser.profileUrl,
        callId: callId,
        hasDialled: true);

    final receiverCallData = Call(
        callerId: senderUser.id,
        callerName: senderUser.name,
        callerPic: senderUser.profileUrl,
        receiverId: contactUser.id,
        receiverName: contactUser.name,
        receiverPic: contactUser.profileUrl,
        callId: callId,
        hasDialled: false);

    BlocProvider.of<CallBloc>(context).add(
        MakeCallEvent(
        senderCallData: senderCallData,
        context: context,
        receiverCallData: receiverCallData));
  }

  void makeGroupCall(BuildContext context){
    //ref.read(callControllerProvider).makeCall(context, name, uid, profilePic, true);
    String callId = Uuid().v1();
    final senderCallData= Call(
        callerId: senderUser.id,
        callerName: senderUser.name,
        callerPic: senderUser.profileUrl,
        receiverId: widget.uid,
        receiverName: widget.name,
        receiverPic: widget.profilePic,
        callId: callId,
        hasDialled: true);

    final receiverCallData = Call(
        callerId: senderUser.id,
        callerName: senderUser.name,
        callerPic: senderUser.profileUrl,
        receiverId: widget.uid,
        receiverName: widget.name,
        receiverPic: widget.profilePic,
        callId: callId,
        hasDialled: false);

    BlocProvider.of<CallBloc>(context).add(
        MakeGroupCallEvent(
            senderCallData: senderCallData,
            context: context,
            receiverCallData: receiverCallData));
  }
  void initState() {
    super.initState();
    BlocProvider.of<ReceiverUserBloc>(context).add(WatchReceiverUserEvent(receiverUserID:widget.uid));
    BlocProvider.of<ChatSettingBloc>(context).add(GetChatSetting());
  }

  @override
  Widget build(BuildContext context,) {
    return  BlocBuilder<AuthenticationBloc,AuthenticationState>(
      builder: (context,state) {
        if (state is AuthenticatedState) {
            senderUser = state.user;
            return Stack(
              children: [
                BlocConsumer<ChatSettingBloc,ChatSettingState>(
                    listener:(context,state){
                      if(state is ShowPhotoOnChatSettingState) {
                        setState(() { showPhoto = true;});
                        }
                      else if(state is ShowPhotoOffChatSettingState) {
                        setState(() { showPhoto = false;});
                        }
                      },
                  builder: (context,state) {
                    if(state is ShowPhotoOnChatSettingState){
                      return Container(
                        decoration:BoxDecoration(
                          image:DecorationImage(image: NetworkImage(widget.profilePic),
                            fit:BoxFit.cover,
                          ),
                        ),
                      );
                    }else{
                      return Container();
                    }

                  }
                ),
                Scaffold(
                  backgroundColor: showPhoto?Colors.white70:Colors.black,
                    appBar: AppBar(
                     iconTheme: IconThemeData(color: showPhoto?Colors.black:Colors.white, ),
                      elevation: 0,
                      backgroundColor:showPhoto? Colors.transparent:Colors.black,
                      //appBarColor,
                      title:widget.isGroupChat?Text(widget.name,style:
                      TextStyle(fontSize: 18,color:showPhoto?Colors.black:Colors.white),
                      ):
                      /*StreamBuilder<UserModel>(
                        stream: ref.read(authControllerProvider).userDataById(uid),
                        builder: (context,snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting ){
                            return const Loader();
                          }else{
                            return
                              Column(
                              children: [
                                Text(name),
                                Text(snapshot.data!.online?'online':'offline',
                                  style: const TextStyle(fontSize: 13),
                                )
                              ],
                            );
                          }
                          return Container();
                        }
                    ),*/
                      BlocBuilder<ReceiverUserBloc,ReceiverUserState>(
                          builder: (context,state) {
                            if(state is LoadedReceiverUserState ){
                              contactUser = state.receiverUser;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(state.receiverUser.name,style:
                                      TextStyle(fontSize: 18,color:showPhoto?Colors.black:Colors.white),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration:BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: state.receiverUser.online?Colors.green:Colors.grey,
                                        ),
                                        width:12,
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0),
                                        child: Text(state.receiverUser.online?'online':'offline',
                                          style: const TextStyle(fontSize: 13,color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                            else {return Container();}
                          },


                      ),
                      centerTitle: false,
                      actions: [
                      IconButton(
                          onPressed: (){
                            if(widget.isGroupChat){
                              makeGroupCall(context);
                            }else{
                              makeCall(context);
                            }
                          },
                          icon: Icon(Icons.video_call,color: showPhoto ? Colors.black:Colors.white,),
                        ),

                      IconButton(
                                onPressed: (){
                                  setState(() {showPhoto = !showPhoto;});
                                  BlocProvider.of<ChatSettingBloc>(context).add(SetChatSetting(showPhoto: showPhoto));
                                },
                                icon:Icon(Icons.photo,
                                    color: showPhoto ?themeButtonColor:Colors.grey)

                            ),

                        const SizedBox(width:24)
                      ],
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: ChatList(receiverUserId: widget.uid,
                            isGroupChat:widget.isGroupChat,
                          ),
                        ),
                        BottomChatField(
                            receiverUserId: widget.uid,
                            isGroupChat:widget.isGroupChat,
                            showPhoto: showPhoto,
                        )
                      ],
                    ),
                  ),
              ],
            );
          } else{ return Container();}
        },

    );

  }
}
