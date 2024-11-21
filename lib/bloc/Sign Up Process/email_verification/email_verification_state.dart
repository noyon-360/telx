part of "email_verification_bloc.dart";

abstract class EmailVerificationState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationCodeUpdate extends EmailVerificationState {
  final List<String> codeDigits;

  EmailVerificationCodeUpdate(this.codeDigits);

  @override
  // TODO: implement props
  List<Object?> get props => [codeDigits];
}

class EmailVerificationSubmitting extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}


class EmailVerificationFailure extends EmailVerificationState {
  final String error;

  EmailVerificationFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

// class TimerRunning extends EmailVerificationState {
//   final int remainingTimer;
//
//   TimerRunning(this.remainingTimer);
//   @override
//   // TODO: implement props
//   List<Object?> get props => [remainingTimer];
// }
//
// class TimerCompleteState extends EmailVerificationState {}