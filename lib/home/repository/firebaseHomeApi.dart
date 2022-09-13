import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import 'package:sathiclub/authentication/models/UserModel.dart';

import '../../authentication/models/InterestModel.dart';
import '../../authentication/models/PhotoModel.dart';


class FirebaseHomeApi{

  Future<List<ProfileModel>>getAllUsers()async{
    List<ProfileModel>profileData=[];
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
      for(int i=0;i<userData.length;i++){
        UserModel loadedUser = UserModel(
            id:'default',
            creationDate: DateTime.now(),
            email: 'default',
            password: 'default',
            mobile: 'default',
            termsAgreed: false,
            name: 'default',
            birthDate: DateTime(4000,01,01),
            age: 0,
            gender: 'default',
            orientation: 'default',
            preference: 'default',
            profileIndex: 0,
            activeLocation: const GeoPoint(1.11,1.11),
            description: 'default',
            distancePreference: 80,
            agePreference: [25,30],
            likes: 0,
            views: 0,
            coins: 0,
            online: false,
            activeDate: DateTime.now(),
            profileUrl: 'default'
        );
        List<InterestModel>loadedInterests=[];
        List<PhotoModel>loadedPhotos=[];
        try {
          var snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userData[i].id)
              .get();
          if (snapshot.exists) {
            loadedUser  = UserModel.fromJson(snapshot.data()!);
          }
        } catch (e) {
          //print(e);
        }
        try {
          var response = await FirebaseFirestore.instance
              .collection('users')
              .doc(userData[i].id)
              .collection('interests')
              .get();
          if (response.docs.isNotEmpty) {
            loadedInterests = response.docs.map((doc) => InterestModel.fromJson(doc.data())).toList();
          }
        } catch (e) {
          //print(e);
        }
        try {
          var response = await FirebaseFirestore.instance
              .collection('users')
              .doc(userData[i].id)
              .collection('photos')
              .get();
          if (response.docs.isNotEmpty) {
            loadedPhotos = response.docs.map((doc) => PhotoModel.fromJson(doc.data())).toList();
          }
          } catch (e) {
          // print(e);
        }
        final ProfileModel loadedProfile = ProfileModel(user: loadedUser, interests: loadedInterests, photos: loadedPhotos);
        profileData.add(loadedProfile);
      }
    }catch(err){
      // print(err);
    }


    return profileData;
  }
  Future<bool>hitLike({required String currentUID,required String likedUID})async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(likedUID).collection('likes').doc(currentUID);
      await docUser.set({
        'like':currentUID,
      });
      final docUserCurrent = await FirebaseFirestore.instance.collection('users').doc(currentUID).collection('liked').doc(likedUID);
      await docUserCurrent.set({
        'liked':likedUID,
      });

      updated = true;
    }catch(e){

      print(e);
      updated = false;
    }
    return updated;
  }
  Future<bool>hitSuperLike({required String currentUID,required String likedUID})async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(likedUID).collection('superLikes').doc(currentUID);
      await docUser.set({
        'superLike':currentUID,
      });
      final docUserCurrent = await FirebaseFirestore.instance.collection('users').doc(currentUID).collection('superLiked').doc(likedUID);
      await docUserCurrent.set({
        'superLiked':likedUID,
      });
      updated = true;
    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }
  Future<String>getView()async{
    String view = 'swipe';
    try{
      final mUserId = FirebaseAuth.instance.currentUser!.uid;
      var docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(mUserId)
          .collection('settings')
          .doc('viewSetting')
          .get();
      if(docSnapshot.exists){
        final fetchedView = docSnapshot['view'];
        view =  fetchedView;
      }
    }catch(e){
      //print(e);
    }

    return view;
  }
  Future<bool>setView(String view)async{
    bool updated = false;
    try{
      final mUserId = FirebaseAuth.instance.currentUser!.uid;
      final docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(mUserId)
          .collection('settings')
          .doc('viewSetting')
      ;
      await docUser.update({
        'view':view,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  int getDistance({required GeoPoint currentPosition, required GeoPoint profilePosition})  {
    int distance = 1 ;
    double _distanceInMeters =  Geolocator.distanceBetween(
      profilePosition.latitude,
      profilePosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    double _distanceInKiloMeters = _distanceInMeters/1000;

    distance = _distanceInKiloMeters.toInt();
    return distance;

  }

  int compareInt(int value1, int value2) =>
      ((value2.compareTo(value1)));






}