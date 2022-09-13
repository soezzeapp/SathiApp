

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/UserModel.dart';

class DefaultUser{
  static final UserModel defaultUser = UserModel(
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



}

