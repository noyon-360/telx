import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_info_event.dart';

part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(Initial()) {
    // on<NextStep>((event, emit){
    //   if(state is Step1){
    //     emit(const Step2());
    //   }
    //   else if(state is Step2){
    //     emit(const Step3());
    //   }
    //   else if(state is Step3){
    //     // emit(const Confirmed);
    //   }
    // });

    on<ConfirmAccount>((event, emit) {
      // emit(const Confirmed());
      print(event.birthday);
      print(event.gender);
      emit(Confirmed(
          event.fullName, event.userName, event.birthday, event.gender));
    });

    // on<PreviousStep>((event, emit){
    //   if(state is Step2) {
    //     emit(const Step1());
    //   }
    //   else if(state is Step3){
    //     emit(const Step2());
    //   }
    // });
  }
}