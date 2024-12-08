part of 'signup_cubit.dart';

enum PasswordStrength { weak, average, strong, secure }

enum SignupStatus { initial, inProgress, success, failure }

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.confirmedPassword = '',
    this.matchPasswords = false,
    this.matchMessage,
    this.status = SignupStatus.initial,
    this.isValid = false,
    this.passwordVisibility = false,
    this.confirmPasswordVisibility = false,
    this.errorMessage,
    this.isSubmitted = false,
    this.passwordStrength = PasswordStrength.weak,
    this.emailExist = false,
  });

  final String email;
  final String password;
  final String confirmedPassword;
  final bool matchPasswords;
  final String? matchMessage;
  final SignupStatus status;
  final bool passwordVisibility;

  final bool confirmPasswordVisibility;
  final bool isValid;
  final String? errorMessage;
  final bool isSubmitted;
  final PasswordStrength passwordStrength;
  final bool emailExist;

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
        emailExist
      ];

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmedPassword,
    bool? matchPasswords,
    String? matchMessage,
    SignupStatus? status,
    bool? isValid,
    bool? passwordVisibility,
    bool? confirmPasswordVisibility,
    String? errorMessage,
    bool? isSubmitted,
    PasswordStrength? passwordStrength,
    bool? emailExist,
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
      emailExist: emailExist ?? this.emailExist
    );
  }
}
