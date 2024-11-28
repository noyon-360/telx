// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
//
// part 'login_event.dart';
//
// part 'login_state.dart';
//
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   LoginBloc() : super(LoginInitial()) {
//     on<LoginSubmitted>(_onLoginSubmitted);
//     on<TogglePasswordVisibility>(_onPasswordVisibility);
//     on<EmailChanging>(_onEmailChanging);
//   }
//
//   void _onEmailChanging(EmailChanging event, Emitter<LoginState> emit) {
//     final email = event.email;
//
//     // Real-time email validation
//     String? emailError;
//     if (email.isEmpty) {
//       emailError = 'Please enter your email';
//     } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
//       emailError = 'Please enter a valid email';
//     }
//
//   }
//
//
//   Future<void> _onLoginSubmitted(
//       LoginSubmitted event, Emitter<LoginState> emit) async {
//     emit(LoginLoading());
//
//     print(event.email);
//   }
//
//   void _onPasswordVisibility(
//       TogglePasswordVisibility event, Emitter<LoginState> emit) {
//     if (state is PasswordVisibilityState) {
//       final currentState = state as PasswordVisibilityState;
//       emit(currentState.copyWith(isPasswordVisible: !currentState.isPasswordVisible));
//     } else {
//       emit(PasswordVisibilityState(isPasswordVisible: true));
//     }
//   }
// }
