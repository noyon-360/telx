import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/services/data_store_services.dart';
import 'package:telx/src/models/user.dart';
import 'package:telx/src/password.dart';
import 'package:telx/repositories/authentication_repository.dart';
import '../../../src/email.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
        email: email, isValid: Formz.validate([email, state.password])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
        password: password, isValid: Formz.validate([state.email, password])));
  }

  void toggleObscureText() {
    emit(state.copyWith(obscureText: !state.passwordVisibility));
  }

  Future<void> logInWithCredentials(BuildContext context) async {
    print(state.email);
    print(state.password);

    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email.value, password: state.password.value);
      StoreDate.saveUserEmail(state.email.value);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(state.email.value)
          .get();
      if (!userDoc.exists) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.userInfoDetailsScreen,
          (route) => false,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else if (userDoc.exists) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.homeScreen,
          (route) => false,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        emit(state.copyWith(errorMessage: "No account create"));
      }
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
