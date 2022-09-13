
import 'package:agora_uikit/agora_uikit.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathiclub/authentication/models/UserModel.dart';
import 'package:sathiclub/common/widgets/ShowSnackBar.dart';
import '../../main.dart';
import '../common/defaultUserModel.dart';
import '../models/InterestModel.dart';
import '../models/PhotoModel.dart';
import '../models/ProfileModel.dart';
import '../repository/firebaseAuthApi.dart';


part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState> {
  AuthenticationBloc() :super(InitialAuthenticationState()) {
    on<InitiateRegisterEvent>(_onInitiateRegisterEvent);
    on<CheckAuthenticationStageEvent>(_onCheckAuthenticationStageEvent);

    on<RegisterEvent>(_onRegisterEvent);
    on<UpdateInfoWelcomeAndTermsEvent>(_onUpdateInfoWelcomeAndTermsEvent);

    on<BackFromNameStateEvent>(_onBackFromNameStateEvent);
    on<UpdateInfoNameEvent>(_onUpdateInfoNameEvent);

    on<BackFromDateStateEvent>(_onBackFromDateStateEvent);
    on<UpdateInfoDateEvent>(_onUpdateInfoDateEvent);

    on<BackFromGenderStateEvent>(_onBackFromGenderStateEvent);
    on<UpdateInfoGenderEvent>(_onUpdateInfoGenderEvent);

    on<BackFromOrientationStateEvent>(_onBackFromOrientationStateEvent);
    on<UpdateInfoOrientationEvent>(_onUpdateInfoOrientationEvent);

    on<BackFromPreferenceStateEvent>(_onBackFromPreferenceStateEvent);
    on<UpdateInfoPreferenceEvent>(_onUpdateInfoPreferenceEvent);

    on<BackFromInterestsStateEvent>(_onBackFromInterestsStateEvent);
    on<AddInfoInterestsEachEvent>(_onAddInfoInterestsEachEvent);
    on<DeleteInfoInterestsEachEvent>(_onDeleteInfoInterestsEachEvent);
    on<UpdateInfoInterestsEvent>(_onUpdateInfoInterestsEvent);


    on<BackFromPhotoStateEvent>(_onBackFromPhotoStateEvent);
    on<AddPhotoEvent>(_onAddPhotoEvent);
    on<DeletePhotoEvent>(_onDeletePhotoEvent);
    on<UpdateProfilePicIndexEvent>(_onUpdateProfilePicIndexEvent);
    on<UpdatePhotoEvent>(_onUpdatePhotoEvent);

    on<BackFromLocationStateEvent>(_onBackFromLocationStateEvent);
    on<UpdateInfoLocationEvent>(_onUpdateInfoLocationEvent);

    on<BackFromLoginEvent>(_onBackFromLoginEvent);
    on<LoginEvent>(_onLoginEvent);
    on<InitiateLoginEvent>(_onInitiateLoginEvent);

    on<UpdateInfoDescriptionStateEvent>(_onUpdateInfoDescriptionStateEvent);
    on<BackFromInfoDescriptionStateEvent>(_onBackFromInfoDescriptionStateEvent);

    on<LogoutEvent>(_onLogoutEvent);
    on<ChangeUserInfoEvent>(_onChangeUserInfoEvent);




  }

  Future <void> _onCheckAuthenticationStageEvent(
      CheckAuthenticationStageEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().checkAuthenticationStage(
        userId: event.uid);
    if (user.id == 'default') {
      emit(InitialAuthenticationState());
    } else {
      if (user.termsAgreed == false) {
        emit(InfoWelcomeAndTermsState(user: user, userId: user.id));
      } else {
        if (user.name == 'default') {
          emit(InfoNameState(user: user, userId: user.id));
        } else {
          if (user.birthDate.isAtSameMomentAs(DateTime(4000, 1, 1))) {
            emit(InfoBirthDateState(user: user, userId: user.id));
          } else {
            if (user.gender == 'default') {
              emit(InfoGenderState(user: user, userId: user.id));
            } else {
              if (user.orientation == 'default') {
                emit(InfoOrientationState(user: user, userId: user.id));
              } else {
                if (user.preference == 'default') {
                  emit(InfoPreferenceState(user: user, userId: user.id));
                } else {
                  final interests = await FirebaseAuthApi().getUserInterests(
                      userId: user.id);
                  if (interests.isEmpty) {
                    emit(InfoInterestsState(
                        user: user, userId: user.id, interests: interests));
                  } else {
                    final photos = await FirebaseAuthApi().getUserPhotos(
                        userId: user.id);
                    if (photos.length < 2) {
                      emit(InfoPhotoState(user: user,
                          userId: user.id,photos:photos));
                    } else {
                      if(user.activeLocation==const GeoPoint(1.11,1.11)) {
                        emit(InfoLocationState(user: user, userId: user.id));
                        }else{
                        final profile = FirebaseAuthApi().convertUserToProfile(event.uid, user, interests, photos);
                        FirebaseAuthApi().updateOnlineStateAndActiveDate( true);
                        emit(AuthenticatedState(user: user, userId: user.id,interests:interests,photos:photos,profile: profile));
                        }
                      }
                   }
                }
              }
            }
          }
        }
      }
    }
  }

  Future<void> _onInitiateRegisterEvent(InitiateRegisterEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(SignUpState(isLoading:true));
  }

  Future<void> _onRegisterEvent(RegisterEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(SignUpState(isLoading:true));
    final user = await FirebaseAuthApi().createUser(
        event.emailId, event.password,event.context);
    if (user.id == 'default') {
      emit(SignUpState(isLoading:false));
    } else {
      final successSetting = await FirebaseAuthApi().setSettings(
          user.id, );
      if(successSetting){
        emit(InfoWelcomeAndTermsState(user: user, userId: user.id));
      }
    }
  }


  Future<void> _onUpdateInfoWelcomeAndTermsEvent(
      UpdateInfoWelcomeAndTermsEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateInfoWelcomeAndTerms(
        event.uid, event.agreedTerms);
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    if (success) {
      InfoWelcomeAndTermsState(userId:event.uid,user:user,);
      emit(InfoNameState(userId: event.uid, user: user));
    }
  }


  Future<void> _onBackFromNameStateEvent(BackFromNameStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoWelcomeAndTermsState(userId: event.uid, user: event.user));

  }
  Future<void> _onUpdateInfoNameEvent(UpdateInfoNameEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateName(event.uid, event.name);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      InfoNameState(userId: event.uid,user: user);
      emit(InfoBirthDateState(userId: event.uid, user: user));
    }
  }


  Future<void> _onBackFromDateStateEvent(BackFromDateStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoNameState(userId: event.uid, user: event.user));
  }
  Future<void> _onUpdateInfoDateEvent(UpdateInfoDateEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateDateOfBirth(
        event.uid, event.date, event.age);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      InfoBirthDateState(userId: event.uid,user:user);
      emit(InfoGenderState(userId: event.uid, user: user));
    }
  }


  Future<void> _onBackFromGenderStateEvent(BackFromGenderStateEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    emit(InfoBirthDateState(userId: event.uid, user: user));
  }
  Future<void> _onUpdateInfoGenderEvent(UpdateInfoGenderEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateGender(event.uid, event.gender);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      InfoGenderState(userId: event.uid, user: user);
      emit(InfoOrientationState(userId: event.uid, user: user));
    }
  }

  Future<void> _onBackFromOrientationStateEvent(
      BackFromOrientationStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoGenderState(userId: event.uid, user: event.user));
  }
  Future<void> _onUpdateInfoOrientationEvent(UpdateInfoOrientationEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateOrientation(
        event.uid, event.orientation);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      InfoOrientationState(userId: event.uid,user:user);
      emit(InfoPreferenceState(userId: event.uid, user: user));
    }
  }



  Future<void> _onBackFromPreferenceStateEvent(
      BackFromPreferenceStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoOrientationState(userId: event.uid, user: event.user));
  }
  Future<void> _onUpdateInfoPreferenceEvent(UpdateInfoPreferenceEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updatePreference(
        event.uid, event.preference);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      final interests = await FirebaseAuthApi().getUserInterests(userId: event.uid);
      InfoPreferenceState(userId: event.uid,user: user);
      emit(InfoInterestsState(
          userId: event.uid, user: user, interests: interests));
    }
  }



  Future<void> _onBackFromInterestsStateEvent(BackFromInterestsStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoPreferenceState(userId: event.uid, user: event.user));
  }
  Future<void> _onAddInfoInterestsEachEvent(AddInfoInterestsEachEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().createInterest(
        event.uid, event.interest);
  }
  Future<void> _onDeleteInfoInterestsEachEvent(
      DeleteInfoInterestsEachEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().deleteInterest(
        event.uid, event.interest);
  }
  Future<void> _onUpdateInfoInterestsEvent(UpdateInfoInterestsEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    final interests = await FirebaseAuthApi().getUserInterests(
        userId: event.uid);
    final photos = await FirebaseAuthApi().getUserPhotos(
        userId: event.uid);
    InfoInterestsState(userId: event.uid, user: user, interests: interests);
    emit(InfoPhotoState(userId: event.uid, user: user,photos: photos));
  }


  Future<void> _onBackFromPhotoStateEvent(BackFromPhotoStateEvent event,
      Emitter<AuthenticationState> emit) async {
    final interests = await FirebaseAuthApi().getUserInterests( userId: event.uid);
    emit(InfoInterestsState(
        userId: event.uid, user: event.user, interests: interests));
  }

  Future<void> _onAddPhotoEvent(AddPhotoEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    final success = await FirebaseAuthApi().createPhoto(
        event.uid, event.url, event.index);
  }

  Future<void> _onDeletePhotoEvent(DeletePhotoEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    final success = await FirebaseAuthApi().deletePhoto(event.uid, event.index);
  }

  Future<void> _onUpdatePhotoEvent(UpdatePhotoEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    final photos = await FirebaseAuthApi().getUserPhotos(userId: event.uid);
    InfoPhotoState(userId: event.uid, user: user, photos: photos);
    emit(InfoLocationState(userId: event.uid, user: user,));
  }

  Future<void> _onUpdateProfilePicIndexEvent(UpdateProfilePicIndexEvent event,
      Emitter<AuthenticationState> emit) async {
    final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
    await FirebaseAuthApi().updateProfilePhotoIndex(event.uid, event.index,event.profileUrl);
  }

  Future<void> _onBackFromLocationStateEvent(BackFromLocationStateEvent event,
      Emitter<AuthenticationState> emit) async {
    final photos = await FirebaseAuthApi().getUserPhotos(
        userId: event.uid);
    emit(InfoPhotoState(
        userId: event.uid, user: event.user, photos:photos));
  }
  Future<void> _onUpdateInfoLocationEvent(UpdateInfoLocationEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateLocation(
        event.uid, event.location);

    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      InfoLocationState(userId: event.uid, user: user);
      emit(InfoDescriptionState(
          userId: event.uid, user: user,));
    }
  }


  Future<void> _onBackFromInfoDescriptionStateEvent(BackFromInfoDescriptionStateEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InfoLocationState(userId: event.uid, user: event.user));
  }

  Future<void> _onUpdateInfoDescriptionStateEvent(UpdateInfoDescriptionStateEvent event,
      Emitter<AuthenticationState> emit) async {
    final success = await FirebaseAuthApi().updateDescription(
        event.uid, event.description);
    FirebaseAuthApi().updateOnlineStateAndActiveDate(true);
    if (success) {
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      final interests = await FirebaseAuthApi().getUserInterests(userId: event.uid);
      final photos = await FirebaseAuthApi().getUserPhotos(userId: event.uid);
      final profile = FirebaseAuthApi().convertUserToProfile(event.uid, user, interests, photos);
      emit(AuthenticatedState(
          userId: event.uid, user: user, interests: interests,photos: photos,profile: profile));
    }
  }

  Future<void> _onBackFromLoginEvent(BackFromLoginEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(InitialAuthenticationState());

  }

  Future<void> _onInitiateLoginEvent(InitiateLoginEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(LogInState(isLoading: false));
  }

  Future<void> _onLoginEvent(LoginEvent event,
      Emitter<AuthenticationState> emit) async {
    await FirebaseAuthApi().signInWithEmail(
        event.email, event.password,event.context);
    emit(LogInState(isLoading: true));
    final user = await FirebaseAuthApi().checkAuthenticationStage(
        userId: 'currentUser');
    if (user.id == 'default') {
      emit(LogInState( isLoading: false));
    } else {
      if (user.termsAgreed == false) {
        emit(InfoWelcomeAndTermsState(user: user, userId: user.id));
      } else {
        if (user.name == 'default') {
          emit(InfoNameState(user: user, userId: user.id));
        } else {
          if (user.birthDate.isAtSameMomentAs(DateTime(4000, 1, 1))) {
            emit(InfoBirthDateState(user: user, userId: user.id));
          } else {
            if (user.gender == 'default') {
              emit(InfoGenderState(user: user, userId: user.id));
            } else {
              if (user.orientation == 'default') {
                emit(InfoOrientationState(user: user, userId: user.id));
              } else {
                if (user.preference == 'default') {
                  emit(InfoPreferenceState(user: user, userId: user.id));
                } else {
                  final interests = await FirebaseAuthApi().getUserInterests(
                      userId: user.id);
                  if (interests.isEmpty) {
                    emit(InfoInterestsState(
                        user: user, userId: user.id, interests: interests));
                  } else {
                    final photos = await FirebaseAuthApi().getUserPhotos(
                        userId: user.id);
                    if (photos.length < 2) {
                      emit(InfoPhotoState(user: user,
                          userId: user.id,photos:photos));
                    } else {
                      if(user.activeLocation==const GeoPoint(1.11,1.11)) {
                        emit(InfoLocationState(user: user, userId: user.id));
                      }else{
                        final profile = FirebaseAuthApi().convertUserToProfile(user.id, user, interests, photos);
                        FirebaseAuthApi().updateOnlineStateAndActiveDate(true);
                        emit(AuthenticatedState(user: user, userId: user.id,interests:interests,photos:photos,profile:profile));
                      }
                    }
                  }

                }
              }
            }
          }
        }
      }
    }
  }

  Future<void> _onLogoutEvent(LogoutEvent event,
      Emitter<AuthenticationState> emit) async {
    await FirebaseAuthApi().updateOnlineStateAndActiveDate(false);
    //await FirebaseAuthApi().signOut;
    await FirebaseAuth.instance.signOut();
    emit(InitialAuthenticationState());

  }

  Future<void> _onChangeUserInfoEvent(ChangeUserInfoEvent event,
      Emitter<AuthenticationState> emit) async {
    bool success = false;
    if(event.title=='Name'){
      success = await FirebaseAuthApi().updateName(event.uid, event.value);
    }
    else if(event.title=='Phone'){
      success = await FirebaseAuthApi().updatePhone(event.uid, event.value);
    }
    else if(event.title=='Gender'){
      success = await FirebaseAuthApi().updateGender(event.uid, event.value);
    }
    else if(event.title=='Orientation'){
      success = await FirebaseAuthApi().updateOrientation(event.uid, event.value);
    }
    else if(event.title=='Preference'){
      success = await FirebaseAuthApi().updatePreference(event.uid, event.value);
    }
    else if(event.title=='Description'){
      success = await FirebaseAuthApi().updateDescription(event.uid, event.value);
    }
    else if(event.title=='Interests'){
      success = true ;
    }
    else if(event.title=='Photos'){
      success = true ;
    }
    else if(event.title=='ChangePassword'){
      success = await FirebaseAuthApi().changePassword(event.uid,event.value,event.context);
    }

    if (success) {
      List<InterestModel>interests = [];
      List<PhotoModel>photos=[];
      final user = await FirebaseAuthApi().getUserInfo(userId: event.uid);
      if(event.title=='Interests'){
        interests = await FirebaseAuthApi().getUserInterests(userId: event.uid);
      }else {
        interests = event.interests;
      }
      if(event.title=='Photos'){
        photos = await FirebaseAuthApi().getUserPhotos(userId: event.uid);
      }else{
        photos = event.photos;
      }
      final profile = await FirebaseAuthApi().convertUserToProfile(event.uid, user, interests, photos);
      emit(AuthenticatedState(
          userId: event.uid, user: user, interests: interests,photos: photos,profile: profile));
      Navigator.of(event.context).pop();

    }else{
      showSnackBar(context: event.context, content: 'Information cannot be saved now');
      Navigator.of(event.context).pop();
    }


  }




}


