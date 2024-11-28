import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'auth_screen_event.dart';
part 'auth_screen_state.dart';

class AuthScreenBloc extends Bloc<AuthScreenEvent, AuthScreenState> {
  AuthScreenBloc() : super(LoginScreenState()) {
    on<SwitchToLogin>((event, emit) => emit(LoginScreenState()));
    on<SwitchToSignup>((event, emit) => emit(SignupScreenState()));

  }
}