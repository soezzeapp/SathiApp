part of 'message_reply_bloc.dart';

class MessageReplyEvent {
  const MessageReplyEvent();

}
class ActivateMessageReplyEvent extends MessageReplyEvent{
  final MessageReply messageReply;
  ActivateMessageReplyEvent({required this.messageReply});
}
class CancelMessageReplyEvent extends MessageReplyEvent{ }