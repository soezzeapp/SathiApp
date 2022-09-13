import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String>membersUid;
  final DateTime timeSent;

  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      senderId: json['a_senderId'],
      name:  json['b_name'],
      groupId:  json['c_groupId'],
      lastMessage:  json['d_lastMessage'],
      groupPic: json['e_groupPic'],
      membersUid: List<String>.from( json['f_memberUid']),
      timeSent: (json['g_timeSent'] as Timestamp).toDate(),
    );
  }

  Map<String,dynamic>toJson()=>{
    'a_senderId':senderId,
    'b_name':name,
    'c_groupId':groupId,
    'd_lastMessage':lastMessage,
    'e_groupPic':groupPic,
    'f_memberUid':membersUid,
    'g_timeSent':timeSent,

  };




}