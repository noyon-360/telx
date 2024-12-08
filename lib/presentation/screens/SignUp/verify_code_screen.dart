// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:telx/bloc/Sign%20Up%20Process/SignupCubit/signup_cubit.dart';
// import 'package:telx/bloc/Sign%20Up%20Process/email_verification/verify_code_cubit.dart';
// import 'package:telx/config/routes/routes_names.dart';

part of 'signup_view_link.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double boxHeight = deviceHeight / 3;

    return Stack(
      children: [
        BlocListener<VerifyCodeCubit, VerifyCodeState>(
          listener: (context, state) {
            if(state.isSubmitting){
              context.read<LoadingCubit>().startLoading();
            }
            else{
              context.read<LoadingCubit>().stopLoading();
            }

          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: boxHeight * 0.1),
                        const _TopContainers(),
                        const SizedBox(height: 10),
                        const _CodeContainers(),
                        const SizedBox(height: 5),
                        const _TimerContainer(),
                        const SizedBox(height: 10),
                        const _SubmitCode(),
                        const SizedBox(height: 10),
                        const _ChangeEmailContainer()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<LoadingCubit, bool>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, isLoading) {
              return isLoading
                  ? const LoadingPage()
                  : const SizedBox.shrink(); // Show or hide based on state
            })
      ],
    );
  }
}

class _TopContainers extends StatelessWidget {
  const _TopContainers();

  @override
  Widget build(BuildContext context) {
    String email = context.select((SignUpCubit cubit) => cubit.state.email);
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 130,
          child:
          Lottie.asset('assets/email verification.json', fit: BoxFit.cover),
        ),
        const Text(
          "Please verify you account",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        Text(
          'We send verification code to $email. Please check your inbox and enter the code below.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CodeContainers extends StatelessWidget {
  const _CodeContainers();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      builder: (context, state) {
        final cubit = context.read<VerifyCodeCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Container(
              width: 50,
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                cursorColor: isDarkTheme ? Colors.white : Colors.blue,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey : Colors.grey[100],
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    cubit.updateCodeDigit(index, value);
                    if (index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  } else {
                    cubit.clearCodeDigit(index);
                    if (index > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  }
                },
              ),
            );
          }),
        );
      },
    );
  }
}

class _TimerContainer extends StatelessWidget {
  const _TimerContainer();

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString()
        .padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String email = context.select((SignUpCubit cubit) => cubit.state.email);
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
        buildWhen: (previous, current) => previous.timeLeft != current.timeLeft,
        builder: (context, state) {
          final cubit = context.read<VerifyCodeCubit>();

          return state.timeLeft > 0
              ? SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "Resend code in ${_formatTime(state.timeLeft)}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          )
              : SizedBox(
            height: 50,
            child: TextButton(
              onPressed: () {
                cubit.startTimer();
                cubit.resendCode(email);
              },
              child: const Text(
                "Resend Verification Code",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        });
  }
}

String? errorMessage;

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return errorMessage != null
        ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    )
        : const SizedBox.shrink();
  }
}

class _SubmitCode extends StatelessWidget {
  const _SubmitCode();

  @override
  Widget build(BuildContext context) {
    String email = context.select((SignUpCubit cubit) => cubit.state.email);
    String password =
    context.select((SignUpCubit cubit) => cubit.state.password);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          context.read<VerifyCodeCubit>().submitCode(context, email, password);
          print("I am working..");
        },
        child: const Text(
          "Confirm Code",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _ChangeEmailContainer extends StatelessWidget {
  const _ChangeEmailContainer();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Change Email'),
    );
  }
}
