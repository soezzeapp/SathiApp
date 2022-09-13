import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final int id;
  final DateTime creationDate;
  final String url;

  PhotoModel({
    required this.id,
    required this.creationDate,
    required this.url,

  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['a_id'],
      creationDate:(json['b_creationDate'] as Timestamp).toDate() ,
      url: json['c_photo'],
    );
  }
  Map<String,dynamic>toJson()=>{
    'a_id':id,
    'b_creationDate':creationDate,
    'c_photo':url,
  };
}