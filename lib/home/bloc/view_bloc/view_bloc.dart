import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/firebaseHomeApi.dart';

part 'view_event.dart';
part 'view_state.dart';

class ViewBloc extends Bloc<ViewEvent,ViewState> {
  ViewBloc() :super(ViewState(view:'')) {
    on<GetViewEvent>(_onGetViewEvent);
    on<ChangeViewEvent>(_onChangeViewEvent);
  }

  Future <void> _onGetViewEvent(
      GetViewEvent event,
      Emitter<ViewState> emit) async {
    final view = await FirebaseHomeApi().getView();
    emit(ViewState(view:view));
  }

  Future <void> _onChangeViewEvent(
      ChangeViewEvent event,
      Emitter<ViewState> emit) async {
    final success = await FirebaseHomeApi().setView(event.view);
    if(success){
      emit(ViewState(view:event.view));
    }
  }


}