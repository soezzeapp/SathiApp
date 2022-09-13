part of 'receiver_user_bloc.dart';


class ReceiverUserState extends Equatable {
  const ReceiverUserState();
  @override
  List<Object?> get props => [];
}
class LoadingReceiverUserState extends ReceiverUserState{}

class LoadedReceiverUserState extends ReceiverUserState{
  final UserModel receiverUser;
  const LoadedReceiverUserState( {required this.receiverUser,});
  @override
  List<Object?> get props => [receiverUser];
}