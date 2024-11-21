part of "google_button_bloc.dart";

abstract class GoogleButtonState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GoogleButtonInitial extends GoogleButtonState {}
class GoogleButtonLoading extends GoogleButtonState {}
class GoogleButtonSuccess extends GoogleButtonState {}

class GoogleButtonFailure extends GoogleButtonState {
  final String error;

  GoogleButtonFailure(this.error);
}