import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/call.dart';
import '../bloc/call_bloc.dart';
import '../config/agora_config.dart';


class CallScreen extends StatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://chatapp-sathi.herokuapp.com';

  @override
  void initState(){
    super.initState();
    client = AgoraClient(agoraConnectionData: AgoraConnectionData(
      appId: AgoraConfig.agoraAppId,
      channelName: widget.channelId,
      tokenUrl:baseUrl,
    ));

    initAgora();
  }
  void initAgora()async{
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: client==null ? const CircularProgressIndicator():SafeArea(
            child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(client: client!,
                  disconnectButtonChild:
                  BlocBuilder<CallBloc,CallState>(
                    builder: (context,state) {
                      if(state is OnCallState){
                        return IconButton(onPressed:()async{
                          await client!.engine.leaveChannel();
                          /*
                        ref.read(callControllerProvider).endCall(
                            widget.call.callerId, widget.call.receiverId, context,widget.isGroupChat);*/
                          BlocProvider.of<CallBloc>(context).add(EndCallEvent(
                              callerId: state.call.callerId,
                              context: context,
                              receiverId: state.call.receiverId));
                          Navigator.pop(context);
                        },
                            icon:const Icon(Icons.call_end)
                        );
                      }else {return Container();}

                    }
                  ) ,),
              ],
            )
        )
    );
  }
}