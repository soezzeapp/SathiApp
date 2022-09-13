import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sathiclub/authentication/models/VideoModel.dart';
import '../../common/widgets/ShowSnackBar.dart';
import '../common/defaultUserModel.dart';
import '../models/InterestModel.dart';
import '../models/PhotoModel.dart';
import '../models/ProfileModel.dart';
import '../models/UserModel.dart';

class FirebaseAuthApi{
  Future<bool>checkIfExists(String userId)async{
    bool exists = false;
    await FirebaseFirestore.instance.
    collection('users').
    doc(userId).get().then((user){
      exists = user.exists;
    });
    return exists;
  }
  Future<UserModel>checkAuthenticationStage({required String userId}) async {
    UserModel user = DefaultUser.defaultUser;
    String mUserId ;
    if(userId=='currentUser'){
      try{
        mUserId = FirebaseAuth.instance.currentUser!.uid;
      }catch(e){
        return user;
      }
    }else{mUserId = userId;}
    user = await getUserInfo(userId: mUserId);
    return user;
  }
  Future<UserModel> getUserInfo({required String userId}) async {
    UserModel user = UserModel(
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
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        //print('exists');
        user  = UserModel.fromJson(snapshot.data()!);
        return user;
      }
    } catch (e) {
      //print(e);
    }
    return user;
  }
  Future<List<InterestModel>>getUserInterests({required String userId})async{
    List<InterestModel>interests=[];
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('interests')
          .get();
      if (response.docs.isNotEmpty) {
        interests = response.docs.map((doc) => InterestModel.fromJson(doc.data())).toList();
      }
    } catch (e) {
      print(e);
    }
    return interests;
  }
  Future<List<PhotoModel>>getUserPhotos({required String userId})async{
    List<PhotoModel>photos=[];
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .get();
      if (response.docs.isNotEmpty) {
        photos = response.docs.map((doc) => PhotoModel.fromJson(doc.data())).toList();
      }
    } catch (e) {
      //print(userId);
     // print(e);
    }
    return photos;
  }
  Future<UserModel> createUser(String email, String password, BuildContext context) async {
    UserModel user = DefaultUser.defaultUser;
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
      user = UserModel(
          id: docUser.id,
          creationDate: DateTime.now(),
          email: email,
          password: password,
          mobile: 'default',
          termsAgreed: false,
          name: 'default',
          birthDate: DateTime(4000,01,01),
          age: 0,
          gender: 'default',
          orientation: 'default',
          preference: 'default',
          distancePreference: 80,
          profileIndex: 0,
          activeLocation: const GeoPoint(1.11,1.11),
          description: 'default',
          agePreference: [25,30],
          likes: 0,
          views: 0,
          coins: 0,
          online: false,
          activeDate: DateTime.now(),
          profileUrl: 'default'
      );
      final json = user.toJson();
      await docUser.set(json);
      //signInWithEmail(email, password);
    } catch (err) {
      showSnackBar(context: context, content: err.toString());
      //print(err);
      return user;
    }
    return user;
  }
  Future<bool>updateInfoWelcomeAndTerms(String userId,bool accepted)async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'f_termsAgreed':accepted,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateName(String userId,String name)async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'g_name':name,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateDateOfBirth(String userId,DateTime date,int age)async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'h_birthDate':date,
        'i_age':age,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateGender(String userId,String gender)async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'j_gender':gender,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateOrientation(String userId,String orientation )async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'k_orientation':orientation,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updatePreference(String userId,String preference  )async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'l_preference':preference ,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>createInterest(String userId,String interest )async{
    bool updated = false;
    try{
        final docInterest = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('interests')
            .doc();
        await docInterest.set({
          'a_id':docInterest.id,
          'b_creationDate':DateTime.now(),
          'c_interest':interest ,
        });
      updated = true;
    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }
  Future<bool>deleteInterest(String userId,String interest)async{
    bool updated = false;
    final oldInterests = await getUserInterests(userId: userId);
    for(int i=0;i<oldInterests.length;i++){
      if(oldInterests[i].interest==interest){
        try{
          final docInterest = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('interests')
              .doc(oldInterests[i].id);
          await docInterest.delete();
          updated = true;

        }catch(e){
          //print(e);
          updated = false;
        }

      }

    }

    return updated;
  }
  Future<bool>createPhoto(String userId,String url,int index )async{
    bool updated = false;
    try{
      final docPhoto = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .doc(index.toString());
      await docPhoto.set({
        'a_id':index,
        'b_creationDate':DateTime.now(),
        'c_photo':url ,
      });
      updated = true;
    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }
  Future<bool>deletePhoto(String userId,String index)async{
    bool updated = false;
        try{
          final docInterest = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('photos')
              .doc(index);
          await docInterest.delete();
          updated = true;

        }catch(e){
          //print(e);
          updated = false;
        }
    return updated;
  }
  Future<bool>updateProfilePhotoIndex(String userId,int index, String profileUrl)async{
    //print(userId);
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'm_profileIndex':index,
        'w_profileUrl':profileUrl,
      });
      updated = true;

    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }
  Future<bool>updateLocation(String userId,GeoPoint location  )async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'n_activeLocation':location ,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>setSettings(String userId  )async{
    bool updated = false;
    try{
      final docPhotoSetting = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('chatSetting')
      ;
      await docPhotoSetting.set({
        'showPhoto':true ,
      });
      final docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('viewSetting')
      ;
      await docUser.set({
        'view':'swipe' ,
      });

      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<bool>updateDescription(String userId,String description  )async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'o_description':description.isEmpty?'default':description ,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<void>signInWithEmail(String email, String password,BuildContext context)async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }catch(e){
      print(e);
      showSnackBar(context: context, content: e.toString());
    }
  }
  ProfileModel convertUserToProfile(String userId,UserModel user,List<InterestModel>interests,List<PhotoModel>photos ){
    ProfileModel profile = ProfileModel(
        user: user,
        interests: interests,
        photos: photos);
    return profile;

  }
  Future<bool>updateOnlineStateAndActiveDate(bool status)async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
      await docUser.update({
        'u_online':status,
        'v_activeDate':DateTime.now(),
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future <void>signOut()async{
     try{
       await FirebaseAuth.instance.signOut();
     }catch(e){
       print(e);}

  }
  Future<bool>updatePhone(String userId,String phone)async{
    bool updated = false;
    try{
      final docUser = await FirebaseFirestore.instance.collection('users').doc(userId);
      await docUser.update({
        'e_mobile':phone,
      });
      updated = true;

    }catch(e){
      updated = false;
    }
    return updated;
  }
  Future<List<VideoModel>>getUserVideos()async{
    final userId = FirebaseAuth.instance.currentUser!.uid;
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
  Future<bool>createVideo(String userId,String url,String thumbnailUrl)async{
    bool updated = false;
    try{
      final docVideo = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('videos')
          .doc();
      await docVideo.set({
        'a_id':docVideo.id,
        'b_creationDate':DateTime.now(),
        'c_video':url ,
        'd_thumbnail':thumbnailUrl,
      });
      updated = true;
    }catch(e){
      print(e);
      updated = false;
    }
    return updated;
  }
  Future<bool>changePassword(String userId,String newPassword,BuildContext context)async{
    bool updated = false;
    try{
      final currentUser = FirebaseAuth.instance.currentUser;
      await currentUser!.updatePassword(newPassword);
      final docUser = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      await docUser.update({
        'd_password':newPassword,
      });
      updated = true;
    }catch(e){
      showSnackBar(context: context, content: e.toString());
      print(e);
      updated = false;
    }
    return updated;
  }







}
