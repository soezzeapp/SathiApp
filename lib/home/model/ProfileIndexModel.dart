import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sathiclub/authentication/models/InterestModel.dart';

import '../../authentication/models/PhotoModel.dart';
import '../../authentication/models/UserModel.dart';

class ProfileIndexModel {
  final UserModel user;
  final List<InterestModel>interests;
  final List<PhotoModel>photos;
  final int index;

  ProfileIndexModel({
    required this.user,
    required this.interests,
    required this.photos,
    required this.index,
  });

}