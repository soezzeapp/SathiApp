import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sathiclub/authentication/models/PhotoModel.dart';

import '../../authentication/models/InterestModel.dart';
import '../../authentication/models/ProfileModel.dart';
import '../../authentication/models/UserModel.dart';

class FirebaseCommonApi{
  Future<List<ProfileModel>>getProfiles({required List<String>userIDs})async{
    List<ProfileModel>profileData=[];
    for(int i=0;i<userIDs.length;i++){
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
        profileUrl: 'default',
      );
      List<InterestModel>loadedInterests=[];
      List<PhotoModel>loadedPhotos=[];
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userIDs[i])
            .get();
        if (snapshot.exists) {
          loadedUser  = UserModel.fromJson(snapshot.data()!);
        }
      } catch (e) {
        print(e);
      }
      try {
        var response = await FirebaseFirestore.instance
            .collection('users')
            .doc(userIDs[i])
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
            .doc(userIDs[i])
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
    return profileData;
  }

  Future<String>storeFileToFirebase(String ref, File file)async{
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String downloadUrl = '';
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot snap = await uploadTask;
      downloadUrl = await snap.ref.getDownloadURL();
    }catch(e){
      //print(e);
    }

    return downloadUrl;
  }

  Future<String>storeImageToFirebase(String ref, Uint8List dataImage)async{
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String downloadUrl = '';
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putData(dataImage);
      TaskSnapshot snap = await uploadTask;
      downloadUrl = await snap.ref.getDownloadURL();
    }catch(e){
      //print(e);
    }

    return downloadUrl;
  }




}