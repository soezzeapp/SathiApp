import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/message_reply.dart';
part 'message_reply_event.dart';
part 'message_reply_state.dart';

class MessageReplyBloc extends Bloc<MessageReplyEvent,MessageReplyState> {
  MessageReplyBloc() :super(EmptyMessageReplyState()) {
    on<ActivateMessageReplyEvent>(_onActivateMessageReplyEvent);
    on<CancelMessageReplyEvent>(_onCancelMessageReplyEvent);
  }

  void _onActivateMessageReplyEvent(
      ActivateMessageReplyEvent event,
      Emitter<MessageReplyState> emit) async {
      emit(LoadedMessageReplyState(messageReply:event.messageReply));
  }

  void _onCancelMessageReplyEvent(
      CancelMessageReplyEvent event,
      Emitter<MessageReplyState> emit) async {
    emit(EmptyMessageReplyState());
  }
}