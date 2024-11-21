part of "user_info_bloc.dart";

abstract class UserInfoState extends Equatable {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Initial extends UserInfoState{}

// class Step1 extends ProgressState {
//   const Step1() : super(1);
// }
//
// class Step2 extends ProgressState {
//   const Step2() : super(2);
// }
//
// class Step3 extends ProgressState {
//   const Step3() : super(3);
// }

class Confirmed extends UserInfoState {
  final String fullName;
  final String userName;
  final DateTime birthday;
  final String gender;
  Confirmed(this.fullName, this.userName, this.birthday, this.gender) ;
}
