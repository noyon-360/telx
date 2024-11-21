part of "email_verification_bloc.dart";

abstract class EmailVerificationEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CodeChanged extends EmailVerificationEvent {
  final int index;
  final String value;

  CodeChanged(this.index, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [index, value];
}

class SendCode extends EmailVerificationEvent {
  final String userEmail;

  SendCode({required this.userEmail});

  @override
  // TODO: implement props
  List<Object?> get props => [userEmail];
}

class CodeSubmitted extends EmailVerificationEvent {
  CodeSubmitted();
}
//
// class StartTimer extends EmailVerificationEvent{
//   final int duration;
//
//   StartTimer(this.duration);
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [duration];
// }
//
// class Tick extends EmailVerificationEvent {
//   final int remainingTime;
//
//   Tick(this.remainingTime);
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [remainingTime];
// }
//
// class TimerComplete extends EmailVerificationEvent{}
