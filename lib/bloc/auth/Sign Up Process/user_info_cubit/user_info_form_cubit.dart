import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/src/models/user.dart';

part 'user_info_form_state.dart';

class UserInfoFormCubit extends Cubit<UserInfoFormState> {
  UserInfoFormCubit(this._authenticationRepository)
      : super(UserInfoFormState.initial());
  final AuthenticationRepository _authenticationRepository;

  // Update full name
  void updateFullName(String fullName) {
    emit(state.copyWith(fullName: fullName));
  }

  // Update username
  void updateUsername(String username) {
    // String suggestedUsername = _suggestUserName(username);
    if (username.isEmpty) {
      emit(state.copyWith(usernameMessage: null));
      return;
    }

    else if (username.length < 8) {
      emit(state.copyWith(usernameMessage: "Need 8 character"));
      if (!username.contains("_")) {
        emit(state.copyWith(usernameMessage: "Need (_)"));
        return;
      }
      return;
    }
    //
    // else if (username.contains(" ")) {
    //   emit(state.copyWith(usernameMessage: "Need (_)"));
    //   return;
    // }
    else if(username.isNotEmpty && username.length > 8 && username.contains('_')) {
      emit(state.copyWith(usernameMessage: null));
      // Check if the username is unique in Firestore
      _checkUsernameUnique(username);

      // Emit the new state with the suggested username
      emit(state.copyWith(
        username: username,
        usernameMessage: state.isUnique
            ? "Username is available!"
            : "Username is already taken.",
      ));
    }

  }

  Future<void> _checkUsernameUnique(String username) async {
    try {
      emit(state.copyWith(nameLoading: true));
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();


      print(querySnapshot.docs);

      bool isUnique = querySnapshot.docs.isEmpty; // True if available

      // if(isUnique) emit(state.copyWith(nameLoading: false));

      // Emit the updated state with the result (no error)
      emit(state.copyWith(
        isUnique: isUnique,
        nameLoading: false,
        usernameMessage:
            isUnique ? "Username is available!" : "Username is already taken.",
      ));

    } catch (e) {
      // Handle Firestore errors or network issues
      emit(state.copyWith(
        isUnique: false, // You can set it to false to indicate error state
        usernameMessage: "Error checking username. Please try again.",
      ));
      print("Error checking username: $e"); // Log error for debugging
      emit(state.copyWith(nameLoading: false));
    }
  }

  // Update selected date
  void selectDate(DateTime? date) {
    emit(state.copyWith(selectedDate: date));
  }

  // Update selected gender
  void selectGender(String? gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  Future<void> submitForm(BuildContext context) async {
    // Validate that all required fields are filled
    if (state.fullName.isEmpty ||
        state.username.isEmpty ||
        state.selectedDate == null ||
        state.selectedGender == null) {
      emit(state.copyWith(errorMessage: "All fields are required"));
      print("All the values are empty");
      return;
    }
    // final _authenticationRepository = AuthenticationRepository();

    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? "";
    final email = currentUser?.email ?? "";
    // final userId = _authenticationRepository.currentUser.id;
    // final email = _authenticationRepository.currentUser.email;

    try {
      // Show loading state while the request is being processed
      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      print(state.fullName);
      print(state.username);
      print(state.selectedDate);
      print(state.selectedGender);
      print(email);

      final user = UserModel(
        id: userId,
        fullName: state.fullName,
        username: state.username,
        email: email,
        photo: "https://example.com/profile.jpg", // Assuming profilePicture is part of the state
        dateOfBirth: state.selectedDate?.toIso8601String(),
        gender: state.selectedGender,
      );

      print(user);


      // Simulate a network request or form submission logic
      // Replace the following code with a real API call
      final response = await _authenticationRepository.addUserViaApi(user);
      print(response);

      if (response['status'] == 200) {
        // Mark submission as successful
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.homeScreen,
          (route) => false,
        );
      } else {
        // Handle the failure case, show an error message
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: "Failed to create user. Please try again.",
        ));
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: "Submission failed. Please try again.",
      ));
    }
  }
}
