
part of "auth_screen_bloc.dart";

abstract class AuthScreenEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SwitchToLogin extends AuthScreenEvent {}

class SwitchToSignup extends AuthScreenEvent {}
