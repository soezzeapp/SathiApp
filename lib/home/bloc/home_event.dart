part of 'home_bloc.dart';

class HomeEvent {
  const HomeEvent();
}

class GetAllUsersHomeEvent extends HomeEvent{ }

class ChangeToGridViewEvent extends HomeEvent{
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  ChangeToGridViewEvent({required this.profiles,required this.profileData});

}
class ChangeToSwipeViewEvent extends HomeEvent{
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  ChangeToSwipeViewEvent({required this.profiles,required this.profileData});

}
class ChangeToRadarViewEvent extends HomeEvent{
  final UserModel mUser;
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  ChangeToRadarViewEvent({required this.profiles,required this.profileData,required this.mUser});

}



