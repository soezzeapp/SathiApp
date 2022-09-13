import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import 'package:sathiclub/authentication/repository/firebaseAuthApi.dart';
import 'package:sathiclub/home/model/ProfileIndexModel.dart';
import 'package:sathiclub/profile/bloc/profile_video_bloc.dart';

import '../../authentication/models/UserModel.dart';
import '../repository/firebaseHomeApi.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState> {
  HomeBloc() :super(LoadingHomeState()) {
    on<GetAllUsersHomeEvent>(_onGetAllUsersHomeEvent);
    on<ChangeToGridViewEvent>(_onChangeToGridViewEvent);
    on<ChangeToSwipeViewEvent>(_onChangeToSwipeViewEvent);
    on<ChangeToRadarViewEvent>(_onChangeToRadarViewEvent);
  }

  Future <void> _onGetAllUsersHomeEvent(
      GetAllUsersHomeEvent event,
      Emitter<HomeState> emit) async {
    final profiles = await FirebaseHomeApi().getAllUsers();
    final profileData = profiles;
    final view = await FirebaseHomeApi().getView();
    if(view =='grid'){
      emit(LoadedHomeGridState(profiles: profiles,profileData: profileData ));
    }else if(view =='radar'){
      final mUserId = FirebaseAuth.instance.currentUser!.uid;
      final mUser = await FirebaseAuthApi().getUserInfo(userId:mUserId);
      List <int> firstCircle = [26,27,28,36,37,38,29,40,47,51,58,62,69,73,80,81,82,83,84];
      List <int> secondCircle = [4,5,6,13,14,15,16,17,18,19,23,24,30,31,34,42,45,53,56,64,
        67,68,74,75,78,79,85,86,90,96,101,102,103,104,105,106,107];
      List<ProfileModel>firstCircleUsers= [];
      List<ProfileModel>secondCircleUsers = [];
      List<ProfileIndexModel>indexedProfiles = [];
      List <int> indexes = [];
      Map<int,int> indexedPairsMap={};
      int countFirstCircle = 0;
      int countSecondCircle = 0;
      int distanceLimit = mUser.distancePreference;
      int lowerDistanceLimit  = (distanceLimit*.40).toInt();
      for(int i = 0; i<profiles.length;i++){
        final distance = FirebaseHomeApi().getDistance(
            currentPosition: mUser.activeLocation,
            profilePosition: profiles[i].user.activeLocation);
        if(distance <lowerDistanceLimit){
          firstCircleUsers.add(profiles[i]);
        }else if(distance >lowerDistanceLimit&&distance<distanceLimit){
          secondCircleUsers.add(profiles[i]);
        }
      }
      firstCircle.shuffle();
      for(int j = 0;j< firstCircleUsers.length;j++){
        final ProfileIndexModel indexedProfile = ProfileIndexModel(
          user: firstCircleUsers[j].user,
          interests: firstCircleUsers[j].interests,
          photos: firstCircleUsers[j].photos,
          index: firstCircle[j],
        );
        indexedPairsMap[firstCircle[j]]=indexedProfiles.length;
        indexedProfiles.add(indexedProfile);
        indexes.add( firstCircle[j]);
      }
      secondCircle.shuffle();
      for(int k = 0;k< secondCircleUsers.length;k++){
        final ProfileIndexModel indexedProfile = ProfileIndexModel(
          user: secondCircleUsers[k].user,
          interests: secondCircleUsers[k].interests,
          photos: secondCircleUsers[k].photos,
          index: secondCircle[k],
        );
        indexedPairsMap[secondCircle[k]]=indexedProfiles.length;
        indexedProfiles.add(indexedProfile);
        indexes.add(secondCircle[k]);
      }
      emit(LoadedHomeRadarState(
        profiles: profiles,
        profileData:profileData,
        mUser: mUser,
        indexedProfiles: indexedProfiles,
        indexes: indexes,
        indexedPairsMap: indexedPairsMap,
      ));

    } else{
      emit(LoadedHomeState(profiles: profiles,profileData:profileData ));
    }

  }
  Future <void> _onChangeToGridViewEvent(
      ChangeToGridViewEvent event,
      Emitter<HomeState> emit) async {
    emit(LoadedHomeGridState(profiles: event.profiles,profileData: event.profileData ));
  }

  Future <void> _onChangeToSwipeViewEvent(
      ChangeToSwipeViewEvent event,
      Emitter<HomeState> emit) async {
    emit(LoadedHomeState(profiles: event.profiles,profileData:event.profileData ));
  }
  Future <void> _onChangeToRadarViewEvent(
      ChangeToRadarViewEvent event,
      Emitter<HomeState> emit) async {
    List <int> firstCircle = [26,27,28,36,37,38,29,40,47,51,58,62,69,73,80,81,82,83,84];
    List <int> secondCircle = [4,5,6,13,14,15,16,17,18,19,23,24,30,31,34,42,45,53,56,64,
                                67,68,74,75,78,79,85,86,90,96,101,102,103,104,105,106,107];
    List<ProfileModel>firstCircleUsers= [];
    List<ProfileModel>secondCircleUsers = [];
    List<ProfileIndexModel>indexedProfiles = [];
    List <int> indexes = [];
    Map<int,int> indexedPairsMap={};
    int countFirstCircle = 0;
    int countSecondCircle = 0;
    int distanceLimit = event.mUser.distancePreference;
    int lowerDistanceLimit  = (distanceLimit*.40).toInt();
    for(int i = 0; i<event.profiles.length;i++){
      final distance = FirebaseHomeApi().getDistance(
          currentPosition: event.mUser.activeLocation,
          profilePosition: event.profiles[i].user.activeLocation);
      if(distance <lowerDistanceLimit){
        firstCircleUsers.add(event.profiles[i]);
      }else if(distance >lowerDistanceLimit&&distance<distanceLimit){
        secondCircleUsers.add(event.profiles[i]);
      }
    }
    firstCircle.shuffle();
    for(int j = 0;j< firstCircleUsers.length;j++){
      final ProfileIndexModel indexedProfile = ProfileIndexModel(
          user: firstCircleUsers[j].user,
          interests: firstCircleUsers[j].interests,
          photos: firstCircleUsers[j].photos,
          index: firstCircle[j],
      );
      indexedPairsMap[firstCircle[j]]=indexedProfiles.length;
      indexedProfiles.add(indexedProfile);
      indexes.add( firstCircle[j]);
    }
    secondCircle.shuffle();
    for(int k = 0;k< secondCircleUsers.length;k++){
      final ProfileIndexModel indexedProfile = ProfileIndexModel(
          user: secondCircleUsers[k].user,
          interests: secondCircleUsers[k].interests,
          photos: secondCircleUsers[k].photos,
          index: secondCircle[k],
      );
      indexedPairsMap[secondCircle[k]]=indexedProfiles.length;
      indexedProfiles.add(indexedProfile);
      indexes.add(secondCircle[k]);
    }
    emit(LoadedHomeRadarState(
        profiles: event.profiles,
        profileData:event.profileData,
        mUser: event.mUser,
        indexedProfiles: indexedProfiles,
        indexes: indexes,
        indexedPairsMap: indexedPairsMap,
    ));
    /*
    print('Length');
    print(indexedProfiles.length);
    print('index 0');
    print(indexedProfiles[0].index);
    print('index 5');
    print(indexedProfiles[5].index);
    print('Map');
    print(indexedPairsMap);*/


  }


  getAllUsersHomeEvent() {
    add(GetAllUsersHomeEvent());
  }



}