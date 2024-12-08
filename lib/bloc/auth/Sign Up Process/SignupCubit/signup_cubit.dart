import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:telx/repositories/authentication_repository.dart';


import '../../../../presentation/screens/SignUp/signup_view_link.dart';


part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final isEmailValid = _validateEmail(value);

    emit(state.copyWith(email: value, isValid: isEmailValid));
  }

  void passwordChanged(String value) {
    final isPasswordValid = _validatePassword(value);
    final passwordStrength = calculatePasswordStrength(value);

    emit(state.copyWith(
        password: value,
        isValid: isPasswordValid,
        passwordStrength: passwordStrength));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisibility: !state.passwordVisibility));
  }

  void confirmedPasswordChanged(String value) {
    // final isConfirmedPasswordValid = _validatePassword(value);

    print("confirm Password => ${state.confirmedPassword}");

    emit(state.copyWith(
      confirmedPassword: value,
    ));
    _checkPasswordsMatch();
  }

  // void confirmedPasswordChanged(String value) {
  //   final confirmedPassword = ConfirmedPassword.dirty(
  //     password: state.password.value,
  //     value: value,
  //   );
  //   emit(
  //     state.copyWith(
  //       confirmedPassword: confirmedPassword,
  //       isValid: Formz.validate([
  //         state.email,
  //         state.password,
  //         confirmedPassword,
  //       ]),
  //     ),
  //   );
  //   _checkPasswordsMatch();
  // }

  void _checkPasswordsMatch() {
    final password = state.password;
    final confirmedPassword = state.confirmedPassword;

    // print("Password => ${state.password}");

    print("I am matching password $confirmedPassword");

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
      emit(state.copyWith(status: SignupStatus.inProgress));
    emit(state.copyWith(isSubmitted: true));
    if (!state.isValid) {
      emit(state.copyWith(isSubmitted: false));
      return;
    }
    try {
      bool isEmailExist =
          await _authenticationRepository.checkEmailExistence(state.email);

      if (!isEmailExist) {
        emit(state.copyWith(emailExist: false));
        await _authenticationRepository.sendCodeOnEmail(state.email);
        emit(state.copyWith(status: SignupStatus.success));
      }
      else if(isEmailExist){
        emit(state.copyWith(emailExist: true));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.toString(),
      ));
      print("Error: $e");
    } finally {
      emit(state.copyWith(isSubmitted: false, status: SignupStatus.initial));
    }
  }

  // Todo : Validation checking
  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
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
