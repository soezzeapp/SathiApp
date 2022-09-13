part of 'view_bloc.dart';
class ViewState extends Equatable {
  final String view;
  const ViewState({required this.view});
  @override
  List<Object?> get props => [view];
}