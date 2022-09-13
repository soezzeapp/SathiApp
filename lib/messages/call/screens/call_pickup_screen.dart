import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sathiclub/messages/call/bloc/call_bloc.dart';
import 'package:sathiclub/messages/call/repository/call_repository.dart';
import '../../../home/provider/CardProvider.dart';
import '../../models/call.dart';
import 'call_screen.dart';

class CallPickupScreen extends StatelessWidget {
  final Widget scaffold;

  const CallPickupScreen({Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,) {
   /* StreamBuilder<DocumentSnapshot>(
        stream:ref.watch(callControllerProvider).callStream ,
        builder:(context,snapshot){
          if(snapshot.hasData && snapshot.data!.data()!=null){
            Call call = Call.fromJson(snapshot.data!.data()as Map<String,dynamic>);
            if(!call.hasDialled){
              return */
    return StreamBuilder<DocumentSnapshot>(
        stream:FirebaseCallApi().callStream,
        builder: (context,snapshot) {
      if(snapshot.hasData && snapshot.data!.data()!=null){
        Call call = Call.fromJson(snapshot.data!.data()as Map<String,dynamic>);
           if(!call.hasDialled){return Scaffold(
             body: Container(
               alignment: Alignment.center,
               padding: const EdgeInsets.symmetric(vertical: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text('Incoming Call',
                     style: TextStyle(fontSize: 30, color: Colors.black),),
                   const SizedBox(height: 30,),
                   CircleAvatar(
                     backgroundImage: NetworkImage(call.callerPic),
                     maxRadius: 60,
                   ),
                   const SizedBox(height: 30,),
                   Text(call.callerName, style: const TextStyle(fontSize: 25,
                       color: Colors.black,
                       fontWeight: FontWeight.w900),),
                   const SizedBox(height: 30,),
                   const SizedBox(width: 25,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: IconButton(
                             onPressed: () {
                               BlocProvider.of<CallBloc>(context).add(EndCallEvent(
                                   callerId: call.callerId,
                                   context: context,
                                   receiverId: call.receiverId));
                             },
                             icon: const Icon(
                               Icons.call_end, color: Colors.red,)),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: IconButton(
                             onPressed: () {
                               BlocProvider.of<CallBloc>(context).add(ReceiveCallEvent(
                                   call:call));
                               Navigator.push(context,
                                   MaterialPageRoute(builder: (context) =>
                                       CallScreen(
                                           channelId: call.callId,
                                           call:call,
                                           isGroupChat: false)));
                             },
                             icon: const Icon(Icons.call, color: Colors.green,)),
                       ),
                     ],
                   )
                 ],
               ),
             ),
           );
           }else{
             return scaffold;
           }
          }
          else {
            return scaffold;
          }
        }
    );
    // }
  }


}