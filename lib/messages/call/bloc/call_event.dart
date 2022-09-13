part of 'call_bloc.dart';

class CallEvent {
  const CallEvent();
}

class WatchCallEvent extends CallEvent{ }

class MakeCallEvent extends CallEvent{
  Call senderCallData;
  BuildContext context;
  Call receiverCallData;
  MakeCallEvent({
    required this.senderCallData,
    required this.context,
    required this.receiverCallData,
  });
}

class EndCallEvent extends CallEvent{
  String callerId;
  BuildContext context;
  String receiverId;
  EndCallEvent({
    required this.callerId,
    required this.context,
    required this.receiverId,
  });
}
class ReceiveCallEvent extends CallEvent{
  Call call ;
  ReceiveCallEvent({
    required this.call,
  });
}

class MakeGroupCallEvent extends CallEvent{
  Call senderCallData;
  BuildContext context;
  Call receiverCallData;
  MakeGroupCallEvent({
    required this.senderCallData,
    required this.context,
    required this.receiverCallData,
  });
}

class EndGroupCallEvent extends CallEvent{
  String callerId;
  BuildContext context;
  String receiverId;
  EndGroupCallEvent({
    required this.callerId,
    required this.context,
    required this.receiverId,
  });
}