import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final DateTime creationDate;
  final String email;
  final String password;
  final String mobile;
  final bool termsAgreed;
  final String name;
  final DateTime birthDate;
  final int age;
  final String gender;
  final String orientation;
  final String preference;
  final int profileIndex;
  final GeoPoint activeLocation;
  final String description;
  final int distancePreference;
  final List<dynamic> agePreference;
  final int likes;
  final int views;
  final int coins;
  final bool online;
  final DateTime activeDate;
  final String profileUrl;

  UserModel({
    required this.id,
    required this.creationDate,
    required this.email,
    required this.password,
    required this.mobile,
    required this.termsAgreed,
    required this.name,
    required this.birthDate,
    required this.age,
    required this.gender,
    required this.orientation,
    required this.preference,
    required this.profileIndex,
    required this.activeLocation,
    required this.description,
    required this.distancePreference,
    required this.agePreference,
    required this.likes,
    required this.views,
    required this.coins,
    required this.online,
    required this.activeDate,
    required this.profileUrl,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['a_id'],
      creationDate:(json['b_creation'] as Timestamp).toDate() ,
      email: json['c_email'],
      password: json['d_password'],
      mobile: json['e_mobile'],
      termsAgreed: json['f_termsAgreed'],
      name: json['g_name'],
      birthDate: (json['h_birthDate'] as Timestamp).toDate(),
      age: json['i_age'] ,
      gender:json['j_gender'],
      orientation:json['k_orientation'],
      preference:json['l_preference'],
      profileIndex: json['m_profileIndex'],
      activeLocation: json['n_activeLocation'],
      description: json['o_description'],
      distancePreference: json['p_distancePreference'],
      agePreference: json['q_agePreference'],
      likes: json['r_likes'],
      views: json['s_views'],
      coins: json['t_coins'],
      online: json['u_online'],
      activeDate: (json['v_activeDate'] as Timestamp).toDate(),
      profileUrl: json['w_profileUrl'],
    );
  }

  Map<String,dynamic>toJson()=>{
    'a_id':id,
    'b_creation':creationDate,
    'c_email':email,
    'd_password':password,
    'e_mobile':mobile,
    'f_termsAgreed':termsAgreed,
    'g_name':name,
    'h_birthDate':birthDate,
    'i_age':age,
    'j_gender':gender,
    'k_orientation':orientation,
    'l_preference':preference,
    'm_profileIndex':profileIndex,
    'n_activeLocation':activeLocation,
    'o_description':description,
    'p_distancePreference':distancePreference,
    'q_agePreference':agePreference,
    'r_likes':likes,
    's_views':views,
    't_coins':coins,
    'u_online':online,
    'v_activeDate':activeDate,
    'w_profileUrl':profileUrl,
  };
}
