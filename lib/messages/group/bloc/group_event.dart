part of 'group_bloc.dart';

class GroupEvent {
  const GroupEvent();
}

class GetAllUsersGroupEvent extends GroupEvent{ }

class CreateGroupEvent extends GroupEvent {

  final BuildContext context;
  final String name;
  final File profilePic;
  final List<UserModel>selectedContacts;
  CreateGroupEvent({
    required this.context,
    required this.name,
    required this.profilePic,
    required this.selectedContacts,
  });

}
