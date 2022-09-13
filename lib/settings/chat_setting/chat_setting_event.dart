part of 'chat_setting_bloc.dart';

class ChatSettingEvent {
  const ChatSettingEvent();
}

class GetChatSetting extends ChatSettingEvent{ }

class SetChatSetting extends ChatSettingEvent{
  final bool showPhoto;
  SetChatSetting({required this.showPhoto});
}