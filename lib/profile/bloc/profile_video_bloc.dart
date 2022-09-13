import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../authentication/models/VideoModel.dart';
import '../../authentication/repository/firebaseAuthApi.dart';


part 'profile_video_event.dart';
part 'profile_video_state.dart';

class ProfileVideoBloc extends Bloc<ProfileVideoEvent,ProfileVideoState> {
  ProfileVideoBloc() :super(LoadingProfileVideoState()) {
    on<GetAllProfileVideos>(_onGetAllProfileVideos);
    on<SaveProfileVideos>(_onSaveProfileVideos);
  }

  Future <void> _onGetAllProfileVideos(
      GetAllProfileVideos event,
      Emitter<ProfileVideoState> emit) async {
    final videos = await FirebaseAuthApi().getUserVideos();
    if(videos.length!=0){
      emit(LoadedProfileVideoState(profileVideos: videos ));
    }
  }

  Future <void> _onSaveProfileVideos(
      SaveProfileVideos event,
      Emitter<ProfileVideoState> emit) async {
    final success = await FirebaseAuthApi().createVideo(event.userId, event.url,event.thumbnailUrl);
    if(success){
      final videos = await FirebaseAuthApi().getUserVideos();
      if(videos.length!=0){
        emit(LoadedProfileVideoState(profileVideos: videos ));
      }
    }
  }


}