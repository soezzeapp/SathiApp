part of 'chat_bloc.dart';
class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}
class LoadingChatState extends ChatState{}

class LoadedChatState extends ChatState{
final List<Message>chats;
const LoadedChatState( { required this.chats,});

@override
List<Object?> get props => [chats];
}