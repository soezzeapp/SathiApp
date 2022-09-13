import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/ShowSnackBar.dart';
import '../../models/call.dart';
import '../../models/group.dart';
import '../screens/call_screen.dart';

class FirebaseCallApi {
  void makeCall({
    required Call senderCallData,
    required BuildContext context,
    required Call receiverCallData,

    })async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());
      
      await firestore.collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toJson());
      Navigator.push(context,MaterialPageRoute(builder: (context)=>CallScreen(
          channelId: senderCallData.callId,
          call: senderCallData,
          isGroupChat: false)));

    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall({
    required String callerId,
    required String receiverId,
    required BuildContext context,}
    )async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('call')
          .doc(callerId)
          .delete();
      await firestore.collection('call')
          .doc(receiverId)
          .delete();

    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<Call>getCallStream(){
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return firestore.collection('call')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((event)=>Call.fromJson(event.data()!));
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call')
      .doc(auth.currentUser!.uid)
      .snapshots();

  void makeGroupCall({
    required Call senderCallData,
    required BuildContext context,
    required Call receiverCallData,

  })async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());
      var groupSnapShot = await firestore.collection('groups').doc(senderCallData.receiverId).get();
      Group group = Group.fromJson(groupSnapShot.data()!);
      for(var id in group.membersUid){
        await firestore.collection('call')
            .doc(id)
            .set(receiverCallData.toJson());
      }
      Navigator.push(context,MaterialPageRoute(builder: (context)=>CallScreen(
          channelId: senderCallData.callId,
          call: senderCallData,
          isGroupChat: true)));

    }catch(e){
      print(e);
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall({
  required String callerId,
  required String receiverId,
  required BuildContext context,

  })async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('call')
          .doc(callerId)
          .delete();
      var groupSnapShot = await firestore
          .collection('groups')
          .doc(receiverId)
          .get();
      Group group = Group.fromJson(groupSnapShot.data()!);
      for(var id in group.membersUid){
        await firestore.collection('call')
            .doc(id)
            .delete();
      }


    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }




}