
class ChatSettingModel{
  final bool showPhoto;
  ChatSettingModel({
    required this.showPhoto
  });

  static ChatSettingModel fromJson(Map<String,dynamic>json)=>ChatSettingModel(
    showPhoto: json['showPhoto'] ,
  );


}