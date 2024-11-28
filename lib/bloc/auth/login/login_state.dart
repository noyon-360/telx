// part of 'login_bloc.dart';
//
// abstract class LoginState extends Equatable {
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }
//
// class LoginInitial extends LoginState {}
//
// class LoginLoading extends LoginState {}
//
// class EmailVerificationState extends LoginState{
//   final String email;
//   final String? emailError;
//
//   EmailVerificationState({this.email = '', this.emailError});
//
//   EmailVerificationState copyWith({String? email, String? emailError}){
//     return EmailVerificationState(
//       email: email ?? this.email,
//       emailError: emailError
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [email, emailError];
// }
//
// class LoginSuccess extends LoginState {
//   final String email;
//   final String password;
//
//   LoginSuccess({required this.email, required this.password});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [email, password];
// }
//
// class LoginFailure extends LoginState {
//   final String error;
//
//   LoginFailure({required this.error});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [error];
// }
//
// class PasswordVisibilityState extends LoginState {
//   final bool isPasswordVisible;
//
//   PasswordVisibilityState({required this.isPasswordVisible});
//
// // Add copyWith method
//   PasswordVisibilityState copyWith({bool? isPasswordVisible}) {
//     return PasswordVisibilityState(
//       isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
//     );
//   }
//   @override
//   // TODO: implement props
//   List<Object?> get props => [isPasswordVisible];
// }