import 'package:bloc/bloc.dart';

enum AuthScreenState { login, signup }

class AuthSwitchCubit extends Cubit<AuthScreenState> {
  AuthSwitchCubit() : super(AuthScreenState.login);

  void switchLoginScreen() => emit(AuthScreenState.login);

  void switchSignupScreen() => emit(AuthScreenState.signup);
}
