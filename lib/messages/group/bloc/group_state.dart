part of 'group_bloc.dart';
class GroupState extends Equatable {
  const GroupState();
  @override
  List<Object?> get props => [];
}
class LoadingGroupState extends GroupState{}

class LoadedGroupState extends GroupState{
  final List<UserModel>users;
  LoadedGroupState({required this.users});
  @override
  List<Object?> get props => [users];
}