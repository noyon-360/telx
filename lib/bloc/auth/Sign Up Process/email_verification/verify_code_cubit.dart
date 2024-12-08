import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/repositories/authentication_repository.dart';

part 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit(this._authenticationRepository)
      : super(const VerifyCodeState());

  final AuthenticationRepository _authenticationRepository;
  Timer? _timer;

  void updateCodeDigit(int index, String value) {
    final newCodeDigits = List<String>.from(state.codeDigits);
    newCodeDigits[index] = value;
    emit(state.copyWith(codeDigits: newCodeDigits));
  }

  void clearCodeDigit(int index) {
    final newCodeDigits = List<String>.from(state.codeDigits);
    newCodeDigits[index] = '';
    emit(state.copyWith(codeDigits: newCodeDigits));
  }

  Future<void> submitCode(BuildContext context, String email, password) async {
    if (!state.codeDigits
        .every((digit) => RegExp(r'^[0-9]$').hasMatch(digit))) {
      emit(state.copyWith(errorMessage: "Provide the correct numbers"));
      _clearErrorMessage();
      return;
    }

    if (state.codeDigits.any((digit) => digit.isEmpty)) {
      emit(state.copyWith(errorMessage: "Code is incomplete"));
      _clearErrorMessage();
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    final code = state.codeDigits.join();

    try {
      final isCorrect = await _authenticationRepository.verifyCode(email, code);
      print(password);
      if (isCorrect) {
        print("isCorrect : $isCorrect");
        await _authenticationRepository
            .signUp(email: email, password: password)
            .then(
          (value) {
            Navigator.pushNamed(context, RoutesNames.userInfoDetailsScreen);
          },
        );
        emit(state.copyWith(isSuccess: true));
      } else {
        emit(state.copyWith(errorMessage: "Invalid verification code"));
        emit(state.copyWith(isSuccess: false));
        _clearErrorMessage();
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: "An error occurred: $e"));
      _clearErrorMessage();
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void resendCode(String email) async {
    try {
      await _authenticationRepository.sendCodeOnEmail(email);
      emit(state.copyWith(errorMessage: "Code resent, Check your inbox"));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Failed to resend code"));
      _clearErrorMessage();
      print("Error for resend code $e");
    }
  }

  void startTimer() {
    _stopTimer();
    int duration = 15; // in seconds
    emit(state.copyWith(timeLeft: duration));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        duration--;
        emit(state.copyWith(timeLeft: duration));
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    emit(state.copyWith(timeLeft: 0));
  }

  Future<void> _clearErrorMessage() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() {
    _stopTimer(); // Ensure the timer is stopped when the cubit is closed.
    return super.close();
  }

// void startTimer() {
//   int timer = 15; // Start countdown from 15 second
//   emit(state.copyWith(timeLeft: timer));
//
//   Future.doWhile(() async {
//     await Future.delayed(const Duration(seconds: 1));
//     timer--;
//     emit(state.copyWith(timeLeft: timer));
//     return timer > 0;
//   });
// }

// void _countdown() {
//   if (state.timeLeft > 0) {
//     emit(state.copyWith(timeLeft: state.timeLeft - 1));
//     Future.delayed(const Duration(seconds: 1), _countdown);
//   }
// }
}
