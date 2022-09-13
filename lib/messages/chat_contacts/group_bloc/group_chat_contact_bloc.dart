
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/group.dart';
import '../../repository/chat_repository.dart';

part 'group_chat_contact_state.dart';
part 'group_chat_contact_event_bloc.dart';

class GroupChatContactBloc extends Bloc<GroupChatContactEvent,GroupChatContactState> {
  GroupChatContactBloc() :super(LoadingGroupChatContactState()) {
    on<WatchGroupChatContactsEvent>(_onWatchGroupChatContactsEvent);
  }

  void _onWatchGroupChatContactsEvent(
      WatchGroupChatContactsEvent event,
      Emitter<GroupChatContactState> emit) async {
    await emit.forEach(FirebaseChatApi().getChatGroups(),
        onData: (List<Group>chatGroupContacts) {
          return LoadedGroupChatContactState(groupContacts: chatGroupContacts);
        });
  }
}