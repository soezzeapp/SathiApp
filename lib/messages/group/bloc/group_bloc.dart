import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';
import '../../../authentication/models/UserModel.dart';
import '../repository/firebaseGroupApi.dart';


part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent,GroupState> {
  GroupBloc() :super(LoadingGroupState()) {
    on<GetAllUsersGroupEvent>(_onGetAllUsersGroupEvent);
    on<CreateGroupEvent>(_onCreateGroupEvent);

  }

  Future <void> _onGetAllUsersGroupEvent(
      GetAllUsersGroupEvent event,
      Emitter<GroupState> emit) async {
    final users = await FirebaseGroupApi().getAllUsersForGroup();
    emit(LoadedGroupState(users: users, ));
  }

  Future <void> _onCreateGroupEvent(
      CreateGroupEvent event,
      Emitter<GroupState> emit) async {
    await FirebaseGroupApi().createGroup(
        context: event.context,
        name: event.name,
        profilePic: event.profilePic,
        selectedContacts: event.selectedContacts);

  }



}