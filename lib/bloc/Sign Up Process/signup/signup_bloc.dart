// import 'package:bloc/bloc.dart';
// import 'package:telx/repositories/email_verify_code.dart';
// import 'package:equatable/equatable.dart';
//
// part 'signup_event.dart';
//
// part 'signup_state.dart';
//
// class SignupBloc extends Bloc<SignupEvent, SignupState> {
//   SignupBloc() : super(SignupInitialState()) {
//     on<SignupSubmit>(_onSignupSubmit);
//     on<TogglePasswordVisibility>(_onPasswordVisibility);
//     on<ToggleConfirmPasswordVisibility>(_onConfirmPasswordVisibility);
//   }
//
//   Future<void> _onSignupSubmit(
//       SignupSubmit event, Emitter<SignupState> emit) async {
//     emit(SignupLoading());
//
//     print(event.email);
//
//     // try {
//     //   await EmailVerifyCodeRepository.sendVerificationCode(event.email);
//     // } catch (e) {
//     //   print("Error in signup screen email send: ${e.toString()}");
//     // }
//
//     emit(SignupSuccess(
//         email: event.email,
//         password: event.password,
//         confirmPassword: event.confirmPassword));
//   }
//
//   void _onPasswordVisibility(
//       TogglePasswordVisibility event, Emitter<SignupState> emit) {
//     if (state is PasswordVisibilityState) {
//       final isPasswordVisible =
//           (state as PasswordVisibilityState).isPasswordVisible;
//       emit(PasswordVisibilityState(isPasswordVisible: !isPasswordVisible));
//     } else {
//       emit(PasswordVisibilityState(isPasswordVisible: true));
//     }
//   }
//
//   void _onConfirmPasswordVisibility(
//       ToggleConfirmPasswordVisibility event, Emitter<SignupState> emit) {
//     if (state is ConfirmPasswordVisibilityState) {
//       final isConfirmPasswordVisible =
//           (state as ConfirmPasswordVisibilityState).isConfirmPasswordVisible;
//       emit(ConfirmPasswordVisibilityState(
//           isConfirmPasswordVisible: !isConfirmPasswordVisible));
//     } else {
//       emit(ConfirmPasswordVisibilityState(isConfirmPasswordVisible: true));
//     }
//   }
// }
