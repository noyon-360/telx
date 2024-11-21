part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class TogglePasswordVisibility extends LoginEvent {}