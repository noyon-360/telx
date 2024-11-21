import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'google_button_state.dart';
part 'google_button_event.dart';

class GoogleButtonBloc extends Bloc<GoogleButtonEvent, GoogleButtonState> {
  GoogleButtonBloc() : super(GoogleButtonInitial()){
    on<GoogleButtonPressed>(_googleButtonPressed);
  }

  Future<void> _googleButtonPressed (GoogleButtonPressed event, Emitter<GoogleButtonState> emit) async {
    emit(GoogleButtonLoading());
    print("Google is come");
  }
 }