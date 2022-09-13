part of 'profile_video_bloc.dart';


class ProfileVideoState extends Equatable {
  const ProfileVideoState();
  @override
  List<Object?> get props => [];
}
class LoadingProfileVideoState extends ProfileVideoState{}

class LoadedProfileVideoState extends ProfileVideoState{
  final List<VideoModel>profileVideos;
  LoadedProfileVideoState({required this.profileVideos});
  @override
  List<Object?> get props => [profileVideos];
}