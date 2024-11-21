import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onPasswordVisibility);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    print(event.email);
  }

  void _onPasswordVisibility(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    if (state is PasswordVisibilityState) {
      final currentState = state as PasswordVisibilityState;
      emit(currentState.copyWith(isPasswordVisible: !currentState.isPasswordVisible));
    } else {
      emit(PasswordVisibilityState(isPasswordVisible: true));
    }
  }
}
