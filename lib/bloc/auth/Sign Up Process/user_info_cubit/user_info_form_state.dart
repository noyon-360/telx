part of 'user_info_form_cubit.dart';

class UserInfoFormState extends Equatable {
  final String fullName;
  final String username;
  final bool isUnique;
  final String usernameMessage;
  final bool nameLoading;

  final DateTime? selectedDate;
  final String? selectedGender;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const UserInfoFormState({
    this.fullName = '',
    this.username = '',
    this.isUnique = true,
    this.usernameMessage = '',
    this.nameLoading = false,
    this.selectedDate,
    this.selectedGender,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  // Factory for initial state
  factory UserInfoFormState.initial() {
    return const UserInfoFormState();
  }

  // Copy with method for immutability
  UserInfoFormState copyWith({
    String? fullName,
    String? username,
    bool? isUnique,
    String? usernameMessage,
    bool? nameLoading,

    DateTime? selectedDate,
    String? selectedGender,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UserInfoFormState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      isUnique: isUnique ?? this.isUnique,
      usernameMessage: usernameMessage ?? this.usernameMessage,
      nameLoading: nameLoading ?? this.nameLoading,

      selectedDate: selectedDate ?? this.selectedDate,
      selectedGender: selectedGender ?? this.selectedGender,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    username,
    isUnique,
    usernameMessage,
    nameLoading,
    selectedDate,
    selectedGender,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}

