part of 'group_chat_contact_bloc.dart';
class GroupChatContactState extends Equatable {
  const GroupChatContactState();
  @override
  List<Object?> get props => [];
}
class LoadingGroupChatContactState extends GroupChatContactState{}

class LoadedGroupChatContactState extends GroupChatContactState{
  final List<Group>groupContacts;
  const LoadedGroupChatContactState( { required this.groupContacts,});

  @override
  List<Object?> get props => [groupContacts];
}