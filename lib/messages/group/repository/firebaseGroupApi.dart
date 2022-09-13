import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../../authentication/models/UserModel.dart';
import '../../../common/repository/firebaseCommonApi.dart';
import '../../../common/widgets/ShowSnackBar.dart';
import '../../models/group.dart';

class FirebaseGroupApi {
  Future<List<UserModel>>getAllUsersForGroup()async{
    List<UserModel>userData=[];
    try {
      List<UserModel>loadedUsers=[];
      var response = await FirebaseFirestore.instance
          .collection('users')
          .get();
      if(response.docs.isNotEmpty){
        loadedUsers = response.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      }
      userData.addAll(loadedUsers);

    }catch(err){
      // print(err);
    }
    return userData;
  }


 Future<void>  createGroup({
   required BuildContext context,
   required String name,
   required File profilePic,
   required List<UserModel>selectedContacts,

})async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      List<String> uids=[];
      for(int i = 0;i<selectedContacts.length;i++){
          uids.add(selectedContacts[i].id);
      }
      var groupId = const Uuid().v1();
      String profileUrl = await FirebaseCommonApi()
          .storeFileToFirebase('group/$groupId', profilePic);
      Group group = Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [
          auth.currentUser!.uid,
          ...uids,
        ],
        timeSent: DateTime.now(),
      );
      await firestore.collection('groups').doc(groupId).set(group.toJson());


    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }



  }


}