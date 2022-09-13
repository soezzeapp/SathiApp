part of 'receiver_user_bloc.dart';

class ReceiverUserEvent {
  const ReceiverUserEvent();

}

class WatchReceiverUserEvent extends ReceiverUserEvent{
  final String receiverUserID;
  WatchReceiverUserEvent({required this.receiverUserID});

}