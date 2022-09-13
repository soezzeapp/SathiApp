
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContactModel{
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      name:json['a_name'],
      profilePic:json['b_profilePic'],
      contactId: json['c_contactId'],
      timeSent: (json['d_timeSent']as Timestamp).toDate() ,
      lastMessage: json['e_lastMessage'],);
  }
  Map<String,dynamic>toJson()=>{
    'a_name':name,
    'b_profilePic':profilePic,
    'c_contactId':contactId,
    'd_timeSent':timeSent,
    'e_lastMessage':lastMessage,
  };




}