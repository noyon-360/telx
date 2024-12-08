part of 'google_cubit.dart';

abstract class GoogleState {}

class GoogleInitial extends GoogleState {}

class GoogleLoginLoading extends GoogleState {}

class GoogleLoginSuccess extends GoogleState {}

class GoogleLoginUserInfoDetailsNeeded extends GoogleState {}

class GoogleLoginFailure extends GoogleState {
  final String error;

  GoogleLoginFailure(this.error);
}