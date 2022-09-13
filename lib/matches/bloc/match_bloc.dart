import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sathiclub/authentication/models/ProfileModel.dart';

import '../repository/firbaseMatchApi.dart';


part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent,MatchState> {
  MatchBloc() :super( LoadingMatchState()) {
    on<GetMatchesEvent>(_onGetMatchesEvent);

  }

  Future <void> _onGetMatchesEvent(
      GetMatchesEvent event,
      Emitter<MatchState> emit) async {
    final profiles = await FirebaseMatchApi().getMatches();
    if(profiles.isNotEmpty){emit(LoadedMatchState(profiles: profiles ));}
    else {emit(NoMatchState());}

  }

  getMatchesEvent() {
    add(GetMatchesEvent());
  }



}
