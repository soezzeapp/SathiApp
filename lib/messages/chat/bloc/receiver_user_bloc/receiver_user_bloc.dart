import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import 'package:sathiclub/messages/repository/chat_repository.dart';

import '../../../../authentication/models/UserModel.dart';
part 'receiver_user_event.dart';
part 'receiver_user_state.dart';

class ReceiverUserBloc extends Bloc<ReceiverUserEvent,ReceiverUserState> {
  ReceiverUserBloc() :super(LoadingReceiverUserState()) {
    on<WatchReceiverUserEvent>(_onWatchReceiverUserEvent);
  }

  void _onWatchReceiverUserEvent(
      WatchReceiverUserEvent event,
      Emitter<ReceiverUserState> emit) async {
    await emit.forEach(FirebaseChatApi().getUserDataStream(event.receiverUserID),
        onData:(UserModel receiverUser){
          return LoadedReceiverUserState(receiverUser:receiverUser);
        });

  }
}