import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sathiclub/authentication/models/InterestModel.dart';

import 'PhotoModel.dart';
import 'UserModel.dart';

class ProfileModel {
  final UserModel user;
  final List<InterestModel>interests;
  final List<PhotoModel>photos;

  ProfileModel({
    required this.user,
    required this.interests,
    required this.photos,
  });

}