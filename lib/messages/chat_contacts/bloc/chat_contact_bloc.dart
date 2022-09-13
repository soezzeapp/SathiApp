import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import 'package:sathiclub/messages/repository/chat_repository.dart';

import '../../models/chat_contact_model.dart';
import '../../models/group.dart';


part 'chat_contact_event.dart';
part 'chat_contact_state.dart';

class ChatContactBloc extends Bloc<ChatContactEvent,ChatContactState> {
  ChatContactBloc() :super(LoadingChatContactState()) {
    on<WatchChatContactsEvent>(_onWatchChatContactsEvent);

  }

  void _onWatchChatContactsEvent(
      WatchChatContactsEvent event,
      Emitter<ChatContactState> emit) async {
      await emit.forEach(FirebaseChatApi().getChatContacts(),
        onData:(List<ChatContactModel>chatContacts){
          return LoadedChatContactState(chatContacts:chatContacts);
    });
  }


}