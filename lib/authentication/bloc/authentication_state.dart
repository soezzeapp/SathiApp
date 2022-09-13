part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object?> get props => [];
}

class InitialAuthenticationState extends AuthenticationState { }

class SignUpState extends AuthenticationState{
  final bool isLoading;
  SignUpState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}


class InfoWelcomeAndTermsState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoWelcomeAndTermsState({required this.userId, required this.user});
}
class InfoNameState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoNameState({required this.userId, required this.user});
}
class InfoBirthDateState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoBirthDateState({required this.userId, required this.user});
  @override
  List<Object?> get props => [userId,user];
}
class InfoGenderState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoGenderState({required this.userId, required this.user});
  @override
  List<Object?> get props => [userId, user];

}
class InfoOrientationState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoOrientationState({required this.userId, required this.user});

}
class InfoPreferenceState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoPreferenceState({required this.userId, required this.user});

}
class InfoInterestsState extends AuthenticationState{
  final String userId;
  final List<InterestModel>interests;
  final UserModel user;
  const InfoInterestsState({required this.userId, required this.user,required this.interests});

}
class InfoPhotoState extends AuthenticationState{
  final String userId;
  final List<PhotoModel>photos;
  final UserModel user;
  const InfoPhotoState({required this.userId, required this.user,required this.photos});

}
class InfoLocationState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoLocationState({required this.userId, required this.user});

}
class LogInState extends AuthenticationState {
  bool isLoading;
  LogInState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}
class LoggedOutState extends AuthenticationState {}



class InfoDescriptionState extends AuthenticationState{
  final String userId;
  final UserModel user;
  const InfoDescriptionState({required this.userId, required this.user,});
}


class AuthenticatedState extends AuthenticationState {
  final String userId;
  final UserModel user;
  final List<InterestModel>interests;
  final List<PhotoModel>photos;
  final ProfileModel profile;
  const AuthenticatedState({required this.userId, required this.user,required this.interests,
    required this.photos,required this.profile});

  @override
  List<Object?> get props => [userId,user,interests,photos,profile];

}