import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

part 'email_verification_event.dart';

part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final List<String> _codeDigits = List.generate(6, (_) => '');


  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<CodeChanged>((event, emit) {
      _codeDigits[event.index] = event.value;
      emit(EmailVerificationCodeUpdate(List.from(_codeDigits)));
    });

    on<SendCode>((event, emit) async {
      print(event.userEmail);

      // await
      // try {
      //   await EmailVerifyCodeRepository.sendVerificationCode(event.userEmail);
      // } catch (e) {
      //   print("Error : ${e.toString()}");
      // }

      // try {
      //   final response = await http.post(
      //     Uri.parse(Apis.emailSendApi),
      //     headers: {'Content-Type' : 'application/json'},
      //     body: jsonEncode({'email': event.userEmail}),
      //   );
      //   if(response.statusCode == 200) {
      //     print("Verification code is send");
      //   } else {
      //     print("Error");
      //   }
      // } catch(e) {
      //   print(e.toString());
      // }
    });

    on<CodeSubmitted>((event, emit) async {
      emit(EmailVerificationSubmitting());

      final code = _codeDigits.join();
      print(code);
      await Future.delayed(const Duration(seconds: 2));

      if (code.length == 6 && code.isNotEmpty) {
        emit(EmailVerificationSuccess());
      } else {
        emit(EmailVerificationFailure("Fill correct code"));
      }
    });

    // on<StartTimer>((event, emit) {
    //   _timer?.cancel();
    //   emit(TimerRunning(event.duration));
    //   print("Send verification code");
    //
    //   _timer = Timer.periodic(const Duration(seconds: 1), (timer){
    //     final remainingTime = event.duration - timer.tick;
    //
    //     if(remainingTime > 0){
    //       add(Tick(remainingTime));
    //     } else {
    //       add(TimerComplete());
    //       timer.cancel();
    //     }
    //   });
    // });
    //
    // on<Tick>((event, emit){
    //   emit(TimerRunning(event.remainingTime));
    // });
    //
    // on<TimerComplete>((event, emit){
    //   emit(TimerCompleteState());
    // });
    //
    // @override
    // Future<void> close(){
    //   _timer?.cancel();
    //   return super.close();
    // }
  }
}
