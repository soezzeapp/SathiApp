part of 'grid_bloc.dart';
class GridState extends Equatable {
  const GridState();
  @override
  List<Object?> get props => [];
}
class LoadingGridState extends GridState{}


class LoadedLikesGridState extends GridState{
  final List<ProfileModel>profileLikes;
  const LoadedLikesGridState({required this.profileLikes,});
}