part of 'chat_bloc.dart';

class ChatEvent {
  const ChatEvent();
}

class WatchChatsEvent extends ChatEvent{
  String receiverUserId;
  WatchChatsEvent({required this.receiverUserId});

}
class WatchGroupChatsEvent extends ChatEvent{
  String receiverUserId;
  WatchGroupChatsEvent({required this.receiverUserId});

}

class SendTextMessage extends ChatEvent{
  BuildContext context;
  String text;
  String receiverUserId;
  UserModel senderUser;
  MessageReply messageReply;

  SendTextMessage({
    required this.context,
    required this.text,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageReply,
  });
}

class SendFileMessage extends ChatEvent{
  BuildContext context;
  File file;
  String receiverUserId;
  UserModel senderUser;
  MessageEnum messageEnum;
  MessageReply messageReply;

  SendFileMessage({
    required this.context,
    required this.file,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageEnum,
    required this.messageReply,
  });
}

class SendGifMessage extends ChatEvent{
  BuildContext context;
  String gifUrl;
  String receiverUserId;
  UserModel senderUser;
  MessageReply messageReply;

  SendGifMessage({
    required this.context,
    required this.gifUrl,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageReply,
  });

}

class SendDataImageMessage extends ChatEvent{
  BuildContext context;
  Uint8List dataImage;
  String receiverUserId;
  UserModel senderUser;
  MessageEnum messageEnum;
  MessageReply messageReply;

  SendDataImageMessage({
    required this.context,
    required this.dataImage,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageEnum,
    required this.messageReply,
  });
}

class SetChatMessageSeen extends ChatEvent{
  BuildContext context;
  String receiverUserId;
  String messageId;

  SetChatMessageSeen({
    required this.context,
    required this.receiverUserId,
    required this.messageId,
  });

}

class SendTextMessageGroup extends ChatEvent{
  BuildContext context;
  String text;
  String receiverUserId;
  UserModel senderUser;
  MessageReply messageReply;

  SendTextMessageGroup({
    required this.context,
    required this.text,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageReply,
  });
}

class SendFileMessageGroup extends ChatEvent{
  BuildContext context;
  File file;
  String receiverUserId;
  UserModel senderUser;
  MessageEnum messageEnum;
  MessageReply messageReply;

  SendFileMessageGroup({
    required this.context,
    required this.file,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageEnum,
    required this.messageReply,
  });
}

class SendGifMessageGroup extends ChatEvent{
  BuildContext context;
  String gifUrl;
  String receiverUserId;
  UserModel senderUser;
  MessageReply messageReply;

  SendGifMessageGroup({
    required this.context,
    required this.gifUrl,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageReply,
  });

}

class SendDataImageMessageGroup extends ChatEvent{
  BuildContext context;
  Uint8List dataImage;
  String receiverUserId;
  UserModel senderUser;
  MessageEnum messageEnum;
  MessageReply messageReply;
  SendDataImageMessageGroup({
    required this.context,
    required this.dataImage,
    required this.receiverUserId,
    required this.senderUser,
    required this.messageEnum,
    required this.messageReply,
  });
}
