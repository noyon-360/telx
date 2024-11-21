part of "user_info_bloc.dart";

abstract class UserInfoEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NextStep extends UserInfoEvent {}
class ConfirmAccount extends UserInfoEvent {
  final String fullName;
  final String userName;
  final DateTime birthday;
  final String gender;

  ConfirmAccount({required this.fullName, required this.userName, required this.birthday, required this.gender});
}
class PreviousStep extends UserInfoEvent {}
