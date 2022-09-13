part of 'selected_user_video_view_bloc.dart';
class SelectedUserVideoViewState extends Equatable {
  const SelectedUserVideoViewState();
  @override
  List<Object?> get props => [];

}

class LoadingSelectedUserVideoViewState extends SelectedUserVideoViewState{}

class LoadedSelectedUserVideoViewState extends SelectedUserVideoViewState{
  final List<VideoModel> videos;
  LoadedSelectedUserVideoViewState({required this.videos});

  @override
  List<Object?> get props => [videos];

}

