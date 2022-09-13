import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../authentication/models/InterestModel.dart';
import '../../authentication/models/PhotoModel.dart';
import '../../authentication/models/ProfileModel.dart';
import '../../authentication/models/UserModel.dart';
import '../../common/repository/firebaseCommonApi.dart';

class FirebaseGridApi{
  Future<List<ProfileModel>>getAllProfileLikes() async {
    final String _currentUID = FirebaseAuth.instance.currentUser!.uid;
    List<String>likesId = [];
    List<ProfileModel>profileData = [];
    List<UserModel>userData = [];
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUID)
          .collection('likes')
          .get();
      if (response.docs.isNotEmpty) {
        response.docs.forEach((result) {
          likesId.add(result['like']);
        });
        profileData = await FirebaseCommonApi().getProfiles(userIDs: likesId);
      }
    } catch (e) {
      print(e);
    }
    return profileData;
  }

}