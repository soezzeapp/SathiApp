part of 'chat_contact_bloc.dart';


class ChatContactState extends Equatable {
  const ChatContactState();
  @override
  List<Object?> get props => [];
}
class LoadingChatContactState extends ChatContactState{}

class LoadedChatContactState extends ChatContactState{
  final List<ChatContactModel>chatContacts;
  const LoadedChatContactState( { required this.chatContacts,});

  @override
  List<Object?> get props => [chatContacts];
}

