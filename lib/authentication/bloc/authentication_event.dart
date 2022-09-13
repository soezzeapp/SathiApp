part of 'authentication_bloc.dart';

class AuthenticationEvent {
  const AuthenticationEvent();
}

class CheckAuthenticationStageEvent extends AuthenticationEvent{
  String uid;
  CheckAuthenticationStageEvent({required this.uid});
}
class InitiateRegisterEvent extends AuthenticationEvent{}

class RegisterEvent extends AuthenticationEvent {
  String emailId;
  String password;
  BuildContext context;
 RegisterEvent({required this.emailId, required this.password,required this.context});
}
class UpdateInfoWelcomeAndTermsEvent extends AuthenticationEvent{
  String uid;
  bool agreedTerms;
  UpdateInfoWelcomeAndTermsEvent({required this.agreedTerms,required this.uid});
}

class BackFromNameStateEvent extends AuthenticationEvent{
  UserModel user;
  String uid;
  BackFromNameStateEvent({required this.uid, required this.user});
}
class UpdateInfoNameEvent extends AuthenticationEvent{
  String uid;
  String name;
  UpdateInfoNameEvent({required this.name,required this.uid});
}

class BackFromDateStateEvent extends AuthenticationEvent{
  String uid;
  UserModel user;
  BackFromDateStateEvent({required this.uid, required this.user});
}
class UpdateInfoDateEvent extends AuthenticationEvent{
  int age;
  String uid;
  DateTime date;
  UpdateInfoDateEvent({required this.date,required this.uid,required this.age});
}


class BackFromGenderStateEvent extends AuthenticationEvent{
  String uid;
  BackFromGenderStateEvent({required this.uid});
}
class UpdateInfoGenderEvent extends AuthenticationEvent{
  String uid;
  String  gender;
  UpdateInfoGenderEvent({required this.uid,required this.gender});
}


class BackFromOrientationStateEvent extends AuthenticationEvent{
  UserModel user;
  String uid;
  BackFromOrientationStateEvent({required this.uid,required this.user});
}
class UpdateInfoOrientationEvent extends AuthenticationEvent{
  String uid;
  String  orientation ;
  UpdateInfoOrientationEvent({required this.uid,required this.orientation});
}


class BackFromPreferenceStateEvent extends AuthenticationEvent{
  UserModel user;
  String uid;
  BackFromPreferenceStateEvent({required this.uid, required this.user});
}
class UpdateInfoPreferenceEvent extends AuthenticationEvent{
  String uid;
  String  preference  ;
  UpdateInfoPreferenceEvent({required this.uid,required this.preference });
}


class BackFromInterestsStateEvent extends AuthenticationEvent{
  UserModel user;
  String uid;
  BackFromInterestsStateEvent({required this.uid,required this.user});
}
class AddInfoInterestsEachEvent extends AuthenticationEvent{
  String uid;
  String interest  ;
  AddInfoInterestsEachEvent({required this.uid,required this.interest });
}
class DeleteInfoInterestsEachEvent extends AuthenticationEvent{
  String uid;
  String interest  ;
  DeleteInfoInterestsEachEvent({required this.uid,required this.interest });
}
class UpdateInfoInterestsEvent extends AuthenticationEvent{
  String uid;
  List<String>interests  ;
  UpdateInfoInterestsEvent({required this.uid,required this.interests });
}

class BackFromPhotoStateEvent extends AuthenticationEvent{
  String uid;
  UserModel user;
  BackFromPhotoStateEvent({required this.uid,required this.user});
}
class AddPhotoEvent extends AuthenticationEvent{
  int index;
  String uid;
  String url  ;
  AddPhotoEvent({required this.uid,required this.url,required this.index });
}
class DeletePhotoEvent extends AuthenticationEvent{
  String index;
  String uid;
  DeletePhotoEvent({required this.uid,required this.index });
}
class UpdatePhotoEvent extends AuthenticationEvent{
  String uid;
  UpdatePhotoEvent({required this.uid, });
}
class UpdateProfilePicIndexEvent extends AuthenticationEvent{
  int index;
  String uid;
  String profileUrl;
  UpdateProfilePicIndexEvent({required this.uid,required this.index,required this.profileUrl});
}

class BackFromLocationStateEvent extends AuthenticationEvent{
  UserModel user;
  String uid;
  BackFromLocationStateEvent({required this.uid,required this.user});
}
class UpdateInfoLocationEvent extends AuthenticationEvent{
  String uid;
  GeoPoint location  ;
  UpdateInfoLocationEvent({required this.uid,required this.location });
}

class BackFromLoginEvent extends AuthenticationEvent{}
class InitiateLoginEvent extends AuthenticationEvent{}
class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final BuildContext context;
  LoginEvent(
      {required this.email, required this.password,required this.context});
}


class BackFromInfoDescriptionStateEvent  extends AuthenticationEvent{
  String uid;
  UserModel user;
  BackFromInfoDescriptionStateEvent({required this.uid,required this.user});
}
class UpdateInfoDescriptionStateEvent extends AuthenticationEvent{
  String uid;
  String description;
  BuildContext context;
  UpdateInfoDescriptionStateEvent({required this.uid,required this.description,required this.context});
}

class LogoutEvent extends AuthenticationEvent{
  String uid;
  LogoutEvent({required this.uid,});
}

class ChangeUserInfoEvent extends AuthenticationEvent{
  String uid;
  String title;
  String value;
  BuildContext context;
  List<InterestModel>interests;
  List<PhotoModel>photos;
  ChangeUserInfoEvent({
    required this.uid,
    required this.title,
    required this.value,
    required this.context,
    required this.interests,
    required this.photos,
  });
}







