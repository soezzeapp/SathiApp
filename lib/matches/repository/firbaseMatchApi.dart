
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';

import '../../common/repository/firebaseCommonApi.dart';
import '../../home/repository/firebaseHomeApi.dart';

class FirebaseMatchApi{

  Future<List<ProfileModel>>getMatches()async{
  List<ProfileModel>profiles=[];
  List<String>likes=[];
  List<String>liked=[];
  List<String>superLikes=[];
  List<String>superLiked=[];

  likes = await getLikes();
  liked = await getLiked();
  List<String>matches=[];


  for(int i=0;i<liked.length;i++){
    for(int j=0;j<likes.length;j++){
      if(liked[i]==likes[j]){
        matches.add(liked[i]);
      }
    }
    for(int j=0;j<superLikes.length;j++){
      if(liked[i]==superLikes[j]){
        matches.add(liked[i]);
      }
    }
  }
  for(int i=0;i<superLiked.length;i++){
    for(int j=0;j<likes.length;j++){
      if(superLiked[i]==likes[j]){
        matches.add(superLiked[i]);
      }
    }
    for(int j=0;j<superLikes.length;j++){
      if(superLiked[i]==superLikes[j]){
        matches.add(superLiked[i]);
      }
    }
  }
  profiles = await FirebaseHomeApi().getAllUsers();
  if (matches.isNotEmpty){

    //profiles = await FirebaseCommonApi().getProfiles(userIDs: matches);
  }

  return profiles;

  }



  Future<List<String>>getLikes()async{
    final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
    List<String>likesList=[];

    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUID)
          .collection('likes')
          .get();
      if (response.docs.isNotEmpty) {
        response.docs.forEach((result) {
          likesList.add(result['like']);
        });
      }
    } catch (e) {
      print(e);
    }
    return likesList;
  }
  Future<List<String>>getLiked()async{
  final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
  List<String>likedList=[];

  try {
    var response = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUID)
        .collection('liked')
        .get();
    if (response.docs.isNotEmpty) {
      response.docs.forEach((result) {
        likedList.add(result['liked']);
      });
    }
  } catch (e) {
    print(e);
  }
  return likedList;
}
  Future<List<String>>getSuperLikes()async{
    final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
    List<String>likesList=[];

    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUID)
          .collection('superLikes')
          .get();
      if (response.docs.isNotEmpty) {
        response.docs.forEach((result) {
          likesList.add(result['superLike']);
        });
      }
    } catch (e) {
      print(e);
    }
    return likesList;
  }
  Future<List<String>>getSuperLiked()async{
    final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
    List<String>likesList=[];

    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUID)
          .collection('superLiked')
          .get();
      if (response.docs.isNotEmpty) {
        response.docs.forEach((result) {
          likesList.add(result['superLiked']);
        });
      }
    } catch (e) {
      print(e);
    }
    return likesList;
  }

}