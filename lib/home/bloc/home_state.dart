part of 'home_bloc.dart';
class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}
class LoadingHomeState extends HomeState{}

class LoadedHomeState extends HomeState{
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  LoadedHomeState({required this.profiles,required this.profileData});
  @override
  List<Object?> get props => [profiles,profileData];
}
class LoadedHomeGridState extends HomeState{
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  LoadedHomeGridState({required this.profiles,required this.profileData});
  @override
  List<Object?> get props => [profiles,profileData];
}

class LoadedHomeRadarState extends HomeState{
  final List<ProfileModel>profiles;
  final List<ProfileModel>profileData;
  final UserModel mUser;
  final List<ProfileIndexModel>indexedProfiles;
  final List<int>indexes;
  final Map<int,int> indexedPairsMap;
  LoadedHomeRadarState({required this.profiles,required this.profileData,
    required this.mUser,required this.indexedProfiles,required this.indexes,required this.indexedPairsMap});
  @override
  List<Object?> get props => [profiles,profileData];
}