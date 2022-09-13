part of 'view_bloc.dart';

class ViewEvent {
  const ViewEvent();
}

class GetViewEvent extends ViewEvent{ }
class ChangeViewEvent extends ViewEvent{
  String view;
  ChangeViewEvent ({required this.view});
}