

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../authentication/models/VideoModel.dart';

class FirebaseProfileApi{

  Future<List<VideoModel>>getProfileUserVideos({required String userId})async{
    print(userId);
    List<VideoModel>videos=[];
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('videos')
          .get();
      if (response.docs.isNotEmpty) {
        videos = response.docs.map((doc) => VideoModel.fromJson(doc.data())).toList();
      }
    } catch (e) {
      print(e);
    }
    return videos;
  }


}