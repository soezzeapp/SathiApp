import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final DateTime creationDate;
  final String url;
  final String thumbnail;

  VideoModel({
    required this.id,
    required this.creationDate,
    required this.url,
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['a_id'],
      creationDate:(json['b_creationDate'] as Timestamp).toDate() ,
      url: json['c_video'],
      thumbnail: json['d_thumbnail'],

    );
  }
  Map<String,dynamic>toJson()=>{
    'a_id':id,
    'b_creationDate':creationDate,
    'c_video':url,
    'd_thumbnail':thumbnail,
  };
}