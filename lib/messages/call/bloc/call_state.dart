part of 'call_bloc.dart';
class CallState extends Equatable {
  const CallState();
  @override
  List<Object?> get props => [];
}
class OffCallState extends CallState{}

class OnCallState extends CallState{
  final Call call;
  const OnCallState( { required this.call,});
  @override
  List<Object?> get props => [call];

}