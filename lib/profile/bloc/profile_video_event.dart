part of 'profile_video_bloc.dart';

class ProfileVideoEvent {
  const ProfileVideoEvent();
}

class GetAllProfileVideos extends ProfileVideoEvent{
  GetAllProfileVideos();
}
class SaveProfileVideos extends ProfileVideoEvent{
  final String userId;
  final String url;
  final String thumbnailUrl;
  SaveProfileVideos({required this.userId,required this.url,required this.thumbnailUrl});
}



