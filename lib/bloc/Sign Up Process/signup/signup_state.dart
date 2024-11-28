// part of "signup_bloc.dart";
//
// abstract class SignupState extends Equatable {
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }
//
// class SignupInitialState extends SignupState{}
// class SignupLoading extends SignupState{}
//
// class SignupSuccess extends SignupState{
//   final String email;
//   final String password;
//   final String confirmPassword;
//
//   SignupSuccess({required this.email, required this.password, required this.confirmPassword});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [email, password, confirmPassword];
// }
//
// class SignupFailure extends SignupState{
//   final String error;
//
//   SignupFailure({required this.error});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [error];
// }
//
// class PasswordVisibilityState extends SignupState {
//   final bool isPasswordVisible;
//
//   PasswordVisibilityState({required this.isPasswordVisible});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [isPasswordVisible];
// }
//
// class ConfirmPasswordVisibilityState extends SignupState{
//   final bool isConfirmPasswordVisible;
//
//   ConfirmPasswordVisibilityState({required this.isConfirmPasswordVisible});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [isConfirmPasswordVisible];
// }