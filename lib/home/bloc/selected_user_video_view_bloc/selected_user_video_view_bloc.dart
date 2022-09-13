import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sathiclub/profile/repository/FirebaseProfileApi.dart';

import '../../../authentication/models/VideoModel.dart';
import '../../repository/firebaseHomeApi.dart';

part 'selected_user_video_view_event.dart';
part 'selected_user_video_view_state.dart';

class SelectedUserVideoViewBloc extends Bloc<SelectedUserVideoViewEvent,SelectedUserVideoViewState> {
  SelectedUserVideoViewBloc() :super(LoadingSelectedUserVideoViewState()) {
    on<GetSelectedUserVideoViewEvent>(_onGetSelectedUserVideoViewEvent);
  }

  Future <void> _onGetSelectedUserVideoViewEvent(
      GetSelectedUserVideoViewEvent event,
      Emitter<SelectedUserVideoViewState> emit) async {
    final videosList = await FirebaseProfileApi().getProfileUserVideos(userId: event.userId);
    emit(LoadedSelectedUserVideoViewState(videos: videosList));
  }




}