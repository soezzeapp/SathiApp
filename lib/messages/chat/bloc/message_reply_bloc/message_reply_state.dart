part of 'message_reply_bloc.dart';

class MessageReplyState extends Equatable {
  const MessageReplyState();
  @override
  List<Object?> get props => [];
}
class EmptyMessageReplyState extends MessageReplyState{}

class LoadedMessageReplyState extends MessageReplyState{
  final MessageReply messageReply;
  const LoadedMessageReplyState( {required this.messageReply,});
  @override
  List<Object?> get props => [messageReply];
}