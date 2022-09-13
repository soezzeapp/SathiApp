import 'package:cloud_firestore/cloud_firestore.dart';

class InterestModel {
  final String id;
  final DateTime creationDate;
  final String interest;

  InterestModel({
    required this.id,
    required this.creationDate,
    required this.interest,

});

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['a_id'],
      creationDate:(json['b_creationDate'] as Timestamp).toDate() ,
      interest: json['c_interest'],
    );
  }
  Map<String,dynamic>toJson()=>{
    'a_id':id,
    'b_creationDate':creationDate,
    'c_interest':interest,
  };
}