import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sathiclub/common/enum/message_enum.dart';
import 'package:sathiclub/messages/models/message.dart';
import 'package:sathiclub/messages/models/message_reply.dart';
import 'package:sathiclub/messages/repository/chat_repository.dart';

import '../../../authentication/models/UserModel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent,ChatState> {
  ChatBloc() :super(LoadingChatState()) {
    on<WatchChatsEvent>(_onWatchChatsEvent);
    on<SendTextMessage>(_onSendTextMessage);
    on<SendFileMessage>(_onSendFileMessage);
    on<SendGifMessage>(_onSendGifMessage);
    on<SendDataImageMessage>(_onSendDataImageMessage);
    on<SetChatMessageSeen>(_onSetChatMessageSeen);

    on<SendFileMessageGroup>(_onSendFileMessageGroup);
    on<SendGifMessageGroup>(_onSendGifMessageGroup);
    on<SendDataImageMessageGroup>(_onSendDataImageMessageGroup);
    on<WatchGroupChatsEvent>(_onWatchGroupChatsEvent);
    on<SendTextMessageGroup>(_onSendTextMessageGroup);

  }

  void _onWatchChatsEvent(
      WatchChatsEvent event,
      Emitter<ChatState> emit) async {
    await emit.forEach(FirebaseChatApi().getChatStream(event.receiverUserId),
        onData:(List<Message>chats){
          return LoadedChatState(chats:chats);
        });
  }
  void _onWatchGroupChatsEvent(
      WatchGroupChatsEvent event,
      Emitter<ChatState> emit) async {
    await emit.forEach(FirebaseChatApi().getGroupChatStream(event.receiverUserId),
        onData:(List<Message>chats){
          return LoadedChatState(chats:chats);
        });

  }

  Future <void> _onSendTextMessage(
      SendTextMessage event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().sendTextMessage(
        context: event.context,
        text: event.text,
        receiverUserId: event.receiverUserId,
        senderUser: event.senderUser,
        messageReply: event.messageReply);
    }

  Future <void> _onSendFileMessage(
    SendFileMessage event,
    Emitter<ChatState> emit) async {
  FirebaseChatApi().sendFileMessage(
      context: event.context,
      file: event.file,
      receiverUserId: event.receiverUserId,
      senderUser: event.senderUser,
      messageEnum: event.messageEnum,
      messageReply: event.messageReply);
  }

  Future <void> _onSendGifMessage(
      SendGifMessage event,
      Emitter<ChatState> emit) async {
    int gifUrlPartIndex = event.gifUrl.lastIndexOf('-')+1;
    String gifUrlPart = event.gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    FirebaseChatApi().sendGifMessage(
        context: event.context,
        gifUrl: newGifUrl,
        receiverUserId: event.receiverUserId,
        senderUser: event.senderUser,
        messageReply: event.messageReply);
  }

  Future <void> _onSendDataImageMessage(
      SendDataImageMessage event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().sendDataImageMessage(
        context: event.context,
        dataImage: event.dataImage,
        receiverUserId: event.receiverUserId,
        senderUser: event.senderUser,
        messageEnum: event.messageEnum,
        messageReply: event.messageReply);
  }

  Future <void> _onSetChatMessageSeen(
      SetChatMessageSeen event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().setChatMessageSeen(
        context:event.context,
        receiverUserId:event.receiverUserId,
        messageId:event.messageId);
  }


  Future <void> _onSendTextMessageGroup(
      SendTextMessageGroup event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().sendTextMessageGroup(
        context: event.context,
        text: event.text,
        receiverUserId: event.receiverUserId,
        senderUser: event.senderUser,
        messageReply: event.messageReply);
  }

  Future <void> _onSendFileMessageGroup(
      SendFileMessageGroup event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().sendFileMessageGroup(
        context: event.context,
        file: event.file,
        receiverUserId: event.receiverUserId,
        senderUserData: event.senderUser,
        messageEnum: event.messageEnum,
        messageReply: event.messageReply);
  }

  Future <void> _onSendGifMessageGroup(
      SendGifMessageGroup event,
      Emitter<ChatState> emit) async {
    int gifUrlPartIndex = event.gifUrl.lastIndexOf('-')+1;
    String gifUrlPart = event.gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    FirebaseChatApi().sendGifMessageGroup(
        context: event.context,
        gifUrl: newGifUrl,
        receiverUserId: event.receiverUserId,
        senderUser: event.senderUser,
        messageReply: event.messageReply);
  }

  Future <void> _onSendDataImageMessageGroup(
      SendDataImageMessageGroup event,
      Emitter<ChatState> emit) async {
    FirebaseChatApi().sendDataImageMessageGroup(
        context: event.context,
        dataImage: event.dataImage,
        receiverUserId: event.receiverUserId,
        senderUserData: event.senderUser,
        messageEnum: event.messageEnum,
        messageReply: event.messageReply);
  }


}





