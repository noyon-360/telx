part of 'login_cubit.dart';

enum LoginStatus { initial, inProgress, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.isEmailValid = false,
    this.isPassValid = false,
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final bool isEmailValid;
  final bool isPassValid;
  final bool passwordVisibility;
  final String? errorMessage;

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        password,
        status,
        isEmailValid,
        isPassValid,
        passwordVisibility,
        errorMessage
      ];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    bool? isEmailValid,
    bool? isPassValid,
    bool? obscureText,
    String? errorMessage,
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPassValid: isPassValid ?? this.isPassValid,
        passwordVisibility: obscureText ?? passwordVisibility,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
