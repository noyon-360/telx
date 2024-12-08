import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telx/presentation/widgets/snack_bar_helper.dart';
import 'package:telx/repositories/authentication_repository.dart';

part 'google_state.dart';

class GoogleCubit extends Cubit<GoogleState> {
  GoogleCubit(this._authenticationRepository) : super(GoogleInitial());

  final AuthenticationRepository _authenticationRepository;

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      emit(GoogleLoginLoading());
      await _authenticationRepository.logInWithGoogle(context: context);
      emit(GoogleLoginSuccess());
    } on LogInWithGoogleFailure catch (e) {
      emit(GoogleLoginFailure("Google login failed $e"));
      showCustomSnackBar(
          context: context,
          message: "Google login failed",
          type: SnackBarType.failure);
    } catch (_) {
      emit(GoogleLoginFailure("Google login failed"));
      showCustomSnackBar(
          context: context,
          message: "Google login failed",
          type: SnackBarType.failure);
    }
  }
}
