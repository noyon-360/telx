part of 'signup_cubit.dart';

enum PasswordStrength { weak, average, strong, secure }

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.matchPasswords = false,
    this.matchMessage,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.passwordVisibility = false,
    this.confirmPasswordVisibility = false,
    this.errorMessage,
    this.isSubmitted = false,
    this.passwordStrength = PasswordStrength.weak,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool matchPasswords;
  final String? matchMessage;
  final FormzSubmissionStatus status;
  final bool passwordVisibility;

  final bool confirmPasswordVisibility;
  final bool isValid;
  final String? errorMessage;
  final bool isSubmitted;
  final PasswordStrength passwordStrength;

  @override
  List<Object?> get props => [
        email,
        password,
        confirmedPassword,
    matchPasswords,
    matchMessage,
        status,
        isValid,
        passwordVisibility,
        confirmPasswordVisibility,

        errorMessage,
        isSubmitted,
        passwordStrength,
      ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? matchPasswords,
    String? matchMessage,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? passwordVisibility,
    bool? confirmPasswordVisibility,
    String? errorMessage,
    bool? isSubmitted,
    PasswordStrength? passwordStrength,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      matchPasswords: matchPasswords ?? this.matchPasswords,
      matchMessage: matchMessage ?? this.matchMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      confirmPasswordVisibility:
          confirmPasswordVisibility ?? this.confirmPasswordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}
