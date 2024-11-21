part of "auth_screen_bloc.dart";

abstract class AuthScreenState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginScreenState extends AuthScreenState {}

class SignupScreenState extends AuthScreenState {}