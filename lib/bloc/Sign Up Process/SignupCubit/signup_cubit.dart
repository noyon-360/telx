import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:telx/presentation/screens/SignUp/password_strength.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/src/email.dart';
import 'package:telx/src/confirm_password.dart';

import '../../../src/password.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final passwordStrength = calculatePasswordStrength(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        passwordStrength: passwordStrength,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.email,
          password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisibility: !state.passwordVisibility));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
    _checkPasswordsMatch();
  }

  void _checkPasswordsMatch() {
    final password = state.password.value;
    final confirmedPassword = state.confirmedPassword.value;

    if (confirmedPassword.isEmpty) {
      emit(state.copyWith(matchPasswords: false, matchMessage: null));
      return;
    }

    if (password == confirmedPassword) {
      emit(state.copyWith(
          matchPasswords: true, matchMessage: 'Passwords match'));
    } else if (password.startsWith(confirmedPassword)) {
      emit(state.copyWith(
          matchPasswords: false, matchMessage: 'Matching so far...'));
    } else {
      emit(state.copyWith(
          matchPasswords: false, matchMessage: 'Passwords do not match'));
    }
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        confirmPasswordVisibility: !state.confirmPasswordVisibility));
  }

  Future<void> continueToCreateAccount() async {
    emit(state.copyWith(isSubmitted: true));
    if (!state.isValid) {
      emit(state.copyWith(isSubmitted: false));
      return;
    }
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      bool isEmailExist = await _authenticationRepository
          .checkEmailExistence(state.email.value);

      if (!isEmailExist) {
        await _authenticationRepository.sendCodeOnEmail(state.email.value);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
      print("Error: $e");
    } finally {
      emit(state.copyWith(isSubmitted: false));
    }
  }

// Future<void> signUpFormSubmitted() async {
//   emit(state.copyWith(isSubmitted: true));
//   if (!state.isValid) return;
//   emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
//   try {
//     await _authenticationRepository.signUp(
//       email: state.email.value,
//       password: state.password.value,
//     );
//     emit(state.copyWith(status: FormzSubmissionStatus.success));
//   } on SignUpWithEmailAndPasswordFailure catch (e) {
//     emit(
//       state.copyWith(
//         errorMessage: e.message,
//         status: FormzSubmissionStatus.failure,
//       ),
//     );
//   } catch (_) {
//     emit(state.copyWith(status: FormzSubmissionStatus.failure));
//   }
// }
}
