part of 'verify_code_cubit.dart';

@immutable
class VerifyCodeState extends Equatable {
  final List<String> codeDigits;
  final int timeLeft;
  final String? errorMessage;
  final bool isSubmitting;
  final bool? isSuccess;

  const VerifyCodeState(
      {this.codeDigits = const ['', '', '', '', '', ''],
      this.timeLeft = 60,
      this.errorMessage,
      this.isSubmitting = false,
      this.isSuccess
      });

  VerifyCodeState copyWith({
    List<String>? codeDigits,
    int? timeLeft,
    String? errorMessage,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return VerifyCodeState(
        codeDigits: codeDigits ?? this.codeDigits,
        timeLeft: timeLeft ?? this.timeLeft,
        errorMessage: errorMessage,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [codeDigits, timeLeft, errorMessage, isSubmitting, isSuccess];
}
