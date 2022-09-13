part of 'match_bloc.dart';
class MatchState extends Equatable {
  const MatchState();
  @override
  List<Object?> get props => [];
}
class LoadingMatchState extends MatchState{}

class LoadedMatchState extends MatchState{
  final List<ProfileModel>profiles;
  LoadedMatchState({required this.profiles,});
}

class NoMatchState extends MatchState{}