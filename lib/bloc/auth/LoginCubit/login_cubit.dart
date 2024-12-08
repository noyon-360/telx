import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/services/data_store_services.dart';
import 'package:telx/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    // final email = Email.dirty(value);
    final isEmailValid = _validateEmail(value);

    emit(state.copyWith(email: value, isEmailValid: isEmailValid));
  }

  void passwordChanged(String value) {
    final isPasswordValid = _validatePassword(value);

    emit(state.copyWith(password: value, isPassValid: isPasswordValid));
  }

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.passwordVisibility));
  }

  Future<void> logInWithCredentials(BuildContext context) async {
    print(state.email);
    print(state.password);

    if (!state.isEmailValid || !state.isPassValid) return;

    try {
      emit(state.copyWith(status: LoginStatus.inProgress));
      await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email, password: state.password, context: context);
      emit(state.copyWith(status: LoginStatus.initial));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
          state.copyWith(errorMessage: e.message, status: LoginStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  // Todo : Validation checking
  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }
}
