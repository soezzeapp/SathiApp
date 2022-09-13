import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/enum/message_enum.dart';


class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;
  final String senderName;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.senderName,

  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['a_senderId'],
      receiverId: json['b_receiverId'],
      text:json['c_text'],
      type: (json['d_type']as String).toEnum(),
      timeSent: (json['e_timeSent'] as Timestamp).toDate(),
      messageId: json['f_messageId'],
      isSeen: json['g_isSeen'],
      repliedMessage: json['h_repliedMessage'],
      repliedTo: json['i_repliedTo'],
      repliedMessageType:(json['j_repliedMessageType']as String).toEnum() ,
      senderName: json['k_senderName'],
    );
  }
  Map<String,dynamic>toJson()=>{
    'a_senderId':senderId,
    'b_receiverId':receiverId,
    'c_text':text,
    'd_type':type.type,
    'e_timeSent':timeSent,
    'f_messageId':messageId,
    'g_isSeen':isSeen,
    'h_repliedMessage':repliedMessage,
    'i_repliedTo':repliedTo,
    'j_repliedMessageType':repliedMessageType.type,
    'k_senderName':senderName,
  };





}