
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chatSettingModel.dart';

class FirebaseSettingApi{
  Future<bool>setSettingChat(bool showPhoto)async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    bool updated = false;
    try{
      final docChatSetting = await firestore.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('settings')
          .doc('chatSetting')
      ;
      await docChatSetting.set({
        'showPhoto':showPhoto,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>getSettingChat()async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    bool showPhoto = true;
    try{
      ChatSettingModel loaded = ChatSettingModel(showPhoto: true);
      final snapshot = await firestore.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('settings')
          .doc('chatSetting')
          .get();
      if(snapshot.exists){
        loaded = ChatSettingModel.fromJson(snapshot.data()!);
      }
      showPhoto = loaded.showPhoto;

    }catch(e){
      showPhoto = true;
    }
    return showPhoto;
  }


}