import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';

import '../repository/firebaseGridApi.dart';


part 'grid_event.dart';
part 'grid_state.dart';

class GridBloc extends Bloc<GridEvent,GridState> {
  GridBloc() :super(LoadingGridState()) {
    on<GetLikesGridStateEvent>(_onGetLikesGridStateEvent);
  }

  Future <void> _onGetLikesGridStateEvent(
      GetLikesGridStateEvent event,
      Emitter<GridState> emit) async {
    final profileLikes = await FirebaseGridApi().getAllProfileLikes();
    emit(LoadedLikesGridState(profileLikes:profileLikes,));
  }



}