import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/call.dart';
import '../repository/call_repository.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent,CallState> {
  CallBloc() :super( OffCallState()) {
    on<WatchCallEvent>(_onWatchCallEvent);
    on<MakeCallEvent>(_onMakeCallEvent);
    on<ReceiveCallEvent>(_onReceiveCallEvent);
    on<EndCallEvent>(_onEndCallEvent);
    on<MakeGroupCallEvent>(_onMakeGroupCallEvent);
    on<EndGroupCallEvent>(_onEndGroupCallEvent);
  }

  Future<void> _onWatchCallEvent(
      WatchCallEvent event,
      Emitter<CallState> emit) async {
    await emit.forEach(FirebaseCallApi().getCallStream(),
        onData:(Call call){
          emit (OnCallState(call:call));
          return OnCallState(call: call);
        });
  }

  Future <void> _onMakeCallEvent(MakeCallEvent event,
      Emitter<CallState> emit) async {
    FirebaseCallApi().makeCall(
        senderCallData: event.senderCallData,
        context: event.context,
        receiverCallData: event.receiverCallData);
    emit(OnCallState(call:event.senderCallData));
  }

  Future <void> _onEndCallEvent(EndCallEvent event,
      Emitter<CallState> emit) async {
    FirebaseCallApi().endCall(
        callerId: event.callerId,
        receiverId: event.receiverId,
        context: event.context);
        emit(OffCallState());

  }

  Future <void> _onReceiveCallEvent(ReceiveCallEvent event,
      Emitter<CallState> emit) async {
    emit(OnCallState(call: event.call));

  }

  Future <void> _onMakeGroupCallEvent(MakeGroupCallEvent event,
      Emitter<CallState> emit) async {
    FirebaseCallApi().makeGroupCall(
        senderCallData: event.senderCallData,
        context: event.context,
        receiverCallData: event.receiverCallData);
    emit(OnCallState(call:event.senderCallData));
  }

  Future <void> _onEndGroupCallEvent(EndGroupCallEvent event,
      Emitter<CallState> emit) async {
    FirebaseCallApi().endGroupCall(
        callerId: event.callerId,
        receiverId: event.receiverId,
        context: event.context);
    emit(OffCallState());
  }

}