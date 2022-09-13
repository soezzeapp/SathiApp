part of 'selected_user_video_view_bloc.dart';


class SelectedUserVideoViewEvent {
  const SelectedUserVideoViewEvent();
}

class GetSelectedUserVideoViewEvent extends SelectedUserVideoViewEvent{
  String userId;

  GetSelectedUserVideoViewEvent({required this.userId});
}
