import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/firebaseSettingApi.dart';


part 'chat_setting_event.dart';
part 'chat_setting_state.dart';

class ChatSettingBloc extends Bloc<ChatSettingEvent,ChatSettingState> {
  ChatSettingBloc() :super(LoadingChatSettingState()) {
    on<GetChatSetting>(_onGetChatSetting);
    on<SetChatSetting>(_onSetChatSetting);
  }

  Future <void> _onGetChatSetting(
      GetChatSetting event,
      Emitter<ChatSettingState> emit) async {
    final showPhoto = await FirebaseSettingApi().getSettingChat();
    if(showPhoto==true){ emit(ShowPhotoOnChatSettingState());
    } else{
      emit(ShowPhotoOffChatSettingState());
    }

  }

  Future <void> _onSetChatSetting(
      SetChatSetting event,
      Emitter<ChatSettingState> emit) async {
    await FirebaseSettingApi().setSettingChat(event.showPhoto);
    if(event.showPhoto==true){
      emit(ShowPhotoOnChatSettingState());
    }else{
      emit(ShowPhotoOffChatSettingState());
    }
  }

}