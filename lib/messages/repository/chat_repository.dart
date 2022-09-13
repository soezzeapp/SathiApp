import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../authentication/models/UserModel.dart';
import '../../common/enum/message_enum.dart';
import '../../common/repository/firebaseCommonApi.dart';
import '../../common/widgets/ShowSnackBar.dart';
import '../models/chat_contact_model.dart';
import '../models/group.dart';
import '../models/message.dart';
import '../models/message_reply.dart';

class FirebaseChatApi{

  Stream<List<ChatContactModel>>getChatContacts(){
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return firestore.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots().asyncMap((event)async{
      List<ChatContactModel>contacts = [];
      for(var document in event.docs){
        var chatContact = ChatContactModel.fromJson(document.data());
        //var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        //var user = UserModel.fromJson(userData.data()!);
        contacts.add(ChatContactModel(
            name: chatContact.name,
            profilePic: chatContact.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });

  }

  Stream<UserModel>getUserDataStream(String userId){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection('users').doc(userId)
        .snapshots()
        .map((event)=>UserModel.fromJson(event.data()!));
  }
  Stream<List<Message>>getChatStream(String receiverUserId){
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return firestore.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('e_timeSent')
        .snapshots().map((event){
      List<Message>messages = [];
      for(var document in event.docs){
        messages.add(Message.fromJson(document.data()));
      }
      return messages;
    });

  }

  Stream<List<Group>>getChatGroups(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    return firestore.collection('groups')
        .snapshots().asyncMap((event){
      List<Group>groups = [];
      for(var document in event.docs){
        var group = Group.fromJson(document.data());
        if(group.membersUid.contains(auth.currentUser!.uid)){
          groups.add(group);
        }
      }
      return groups;
    });

  }
  Stream<List<Message>>getGroupChatStream(String groupId){
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection('groups')
        .doc(groupId)
        .collection('chats')
        .doc(groupId)
        .collection('messages')
        .orderBy('e_timeSent')
        .snapshots().map((event){
      List<Message>messages = [];
      for(var document in event.docs){
        messages.add(Message.fromJson(document.data()));
      }
      //print (messages.length);
      return messages;
    });

  }


  void _saveDataToContactsSubCollection(
      UserModel senderUserData,
      UserModel receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      )async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    var receiverChatContact = ChatContactModel(
        name: senderUserData.name,
        profilePic: senderUserData.profileUrl,
        contactId: senderUserData.id,
        timeSent: timeSent,
        lastMessage: text);

    await firestore.collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toJson());

    var senderChatContact = ChatContactModel(
        name: receiverUserData.name,
        profilePic: receiverUserData.profileUrl,
        contactId: receiverUserId,
        timeSent: timeSent,
        lastMessage: text);

    await firestore.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toJson());
  }


  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required MessageEnum repliedMessageType,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage:messageReply==null?'':
      messageReply.message,
      repliedTo:messageReply==null?'':
      messageReply.isMe?senderUserName:
      receiverUserName,
      repliedMessageType:repliedMessageType,
      senderName: senderUserName,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }



  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {

      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap = await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
          senderUser,receiverUserData,text,timeSent,receiverUserId);
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );

    }catch(e){
      print(e);
    }

  }


  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  })async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try{
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await FirebaseCommonApi()
          .storeFileToFirebase('chat/${messageEnum.type}/${senderUser.id}/$receiverUserId/$messageId',file);
      UserModel receiverUserData;
      var userDataJson =
      await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataJson.data()!);
      String contactMsg;
      switch(messageEnum){
        case MessageEnum.image:
          contactMsg ='📸 Photo';
          break;
        case MessageEnum.video:
          contactMsg ='📹 Video';
          break;
        case MessageEnum.audio:
          contactMsg ='🎵 Music';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg ='GIF';
      }
      _saveDataToContactsSubCollection(senderUser, receiverUserData, contactMsg, timeSent, receiverUserId);
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType:messageEnum,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );
    } catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }


  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap = await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
          senderUser,receiverUserData,'GIF',timeSent,receiverUserId);
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.gif,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );

    }catch(e){
      print(e);
    }
  }

  Future<void> sendDataImageMessage({
    required BuildContext context,
    required Uint8List dataImage,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  })async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try{
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      /*await ref.read(commonFirebaseStorageRepositoryProvider)
          .storeImageToFirebase('chat/${messageEnum.type}/${senderUserData.id}/$receiverUserId/$messageId',dataImage);*/
      String imageUrl = await FirebaseCommonApi()
          .storeImageToFirebase('chat/${messageEnum.type}/${senderUser.id}/$receiverUserId/$messageId',dataImage);
      UserModel receiverUserData;
      var userDataJson =
      await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataJson.data()!);
      String contactMsg;
      switch(messageEnum){
        case MessageEnum.image:
          contactMsg ='📸 Photo';
          break;
        case MessageEnum.video:
          contactMsg ='📹 Video';
          break;
        case MessageEnum.audio:
          contactMsg ='🎵 Music';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg ='GIF';
      }
      _saveDataToContactsSubCollection(senderUser, receiverUserData, contactMsg, timeSent, receiverUserId);
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData.name,
        messageType:messageEnum,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );
    } catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'g_isSeen':true});

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'g_isSeen':true});


    }catch(e){
      showSnackBar(context: context,content: e.toString());

    }

  }

//...............................Group Repo ...................
  void _saveDataToSubCollectionGroup(
      UserModel senderUserData,
      Group receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      )async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var receiverChatContact = ChatContactModel(
        name: senderUserData.name,
        profilePic: senderUserData.profileUrl,
        contactId: senderUserData.id,
        timeSent: timeSent,
        lastMessage: text);
    await firestore.collection('groups')
        .doc(receiverUserId)
        .collection('chats')
        .doc(receiverUserId)
        .set(receiverChatContact.toJson());
  }

  void _saveMessageToMessageSubCollectionGroup({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required MessageEnum repliedMessageType,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage:messageReply==null?'':
      messageReply.message,
      repliedTo:messageReply==null?'':
      messageReply.isMe?senderUserName:
      receiverUserName,
      repliedMessageType:repliedMessageType,
      senderName: senderUserName,
    );
    await firestore
        .collection('groups')
        .doc(receiverUserId)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }


  void sendTextMessageGroup({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  })async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var timeSent = DateTime.now();
      Group receiverGroupData;
      var userGroupMap = await firestore.collection('groups').doc(receiverUserId).get();
      receiverGroupData = Group.fromJson(userGroupMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToSubCollectionGroup(
          senderUser,receiverGroupData,text,timeSent,receiverUserId);
      _saveMessageToMessageSubCollectionGroup(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverGroupData.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );
    }catch(e){
      print(e);
    }
  }

  Future<void> sendFileMessageGroup({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  })async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await FirebaseCommonApi()
      .storeFileToFirebase('chat/${messageEnum.type}/${senderUserData.id}/$receiverUserId/$messageId',file);
           Group receiverGroupData;
      var userGroupMap = await firestore.collection('groups').doc(receiverUserId).get();
      receiverGroupData = Group.fromJson(userGroupMap.data()!);
      String contactMsg;
      switch(messageEnum){
        case MessageEnum.image:
          contactMsg ='📸 Photo';
          break;
        case MessageEnum.video:
          contactMsg ='📹 Video';
          break;
        case MessageEnum.audio:
          contactMsg ='🎵 Music';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg ='GIF';
      }
      _saveDataToSubCollectionGroup(senderUserData, receiverGroupData, contactMsg, timeSent, receiverUserId);
      _saveMessageToMessageSubCollectionGroup(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverGroupData.name,
        messageType:messageEnum,
        senderUserName: senderUserData.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );
    } catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifMessageGroup({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  })async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var timeSent = DateTime.now();
      Group receiverGroupData;
      var userGroupMap = await firestore.collection('groups').doc(receiverUserId).get();
      receiverGroupData = Group.fromJson(userGroupMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToSubCollectionGroup(
          senderUser,receiverGroupData,'GIF',timeSent,receiverUserId);
      _saveMessageToMessageSubCollectionGroup(
        receiverUserId: receiverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverGroupData.name,
        messageType: MessageEnum.gif,
        senderUserName: senderUser.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );

    }catch(e){
      print(e);
    }
  }

  Future<void> sendDataImageMessageGroup({
    required BuildContext context,
    required Uint8List dataImage,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  })async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await FirebaseCommonApi()
          .storeImageToFirebase('chat/${messageEnum.type}/${senderUserData.id}/$receiverUserId/$messageId',dataImage);
      Group receiverGroupData;
      var userGroupMap = await firestore.collection('groups').doc(receiverUserId).get();
      receiverGroupData = Group.fromJson(userGroupMap.data()!);
      String contactMsg;
      switch(messageEnum){
        case MessageEnum.image:
          contactMsg ='📸 Photo';
          break;
        case MessageEnum.video:
          contactMsg ='📹 Video';
          break;
        case MessageEnum.audio:
          contactMsg ='🎵 Music';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg ='GIF';
      }
      _saveDataToSubCollectionGroup(senderUserData, receiverGroupData, contactMsg, timeSent, receiverUserId);
      _saveMessageToMessageSubCollectionGroup(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverGroupData.name,
        messageType:messageEnum,
        senderUserName: senderUserData.name,
        messageReply: messageReply,
        repliedMessageType:messageReply==null?
        MessageEnum.text:messageReply.messageEnum,
      );
    } catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }









}