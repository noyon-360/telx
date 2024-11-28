part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool passwordVisibility;
  final String? errorMessage;

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, status, isValid, passwordVisibility, errorMessage];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? obscureText,
    String? errorMessage,
}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      passwordVisibility: obscureText ?? passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}