import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:telx/bloc/Sign%20Up%20Process/email_verification/email_verification_bloc.dart';
import 'package:telx/presentation/screens/SignUp/user_form_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String emailAddress;

  const EmailVerificationScreen({super.key, required this.emailAddress});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  Timer? _timer;
  int _timeLeft = 10; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        print("Timer Complete");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxHeight = deviceHeight / 3;

    String formatTime(int seconds) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    return BlocProvider(
      create: (context) => EmailVerificationBloc()
        ..add(SendCode(userEmail: widget.emailAddress)),
      child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserFormScreen()));
          } else if (state is EmailVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is EmailVerificationSubmitting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<EmailVerificationBloc>();
          final codeDigits = state is EmailVerificationCodeUpdate
              ? state.codeDigits
              : List.generate(6, (_) => '');

          return Scaffold(
            // appBar: AppBar(title: const Text("Email Verification")),
            body: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: boxHeight * 0.1,
                            ),
                            SizedBox(
                                // color: Colors.green,
                                width: 150,
                                height: 130,
                                child: Lottie.asset(
                                    'assets/email verification.json',
                                    fit: BoxFit.cover)),
                            const Text(
                              "Please verify you account",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'We send verification code to ${widget.emailAddress}. Please check your inbox and enter the code below.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                return Container(
                                  width: 50,
                                  height: 70,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextFormField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    cursorColor: isDarkTheme
                                        ? Colors.white
                                        : Colors.blue,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[400]!),
                                      ),
                                      filled: true,
                                      fillColor: isDarkTheme
                                          ? Colors.grey
                                          : Colors.grey[100],
                                    ),
                                    onChanged: (value) {
                                      bloc.add(CodeChanged(index, value));
                                      // Todo : Code digit backspace
                                      if (value.isEmpty && index > 0) {
                                        if (index < _focusNodes.length + 1 &&
                                            _controllers[index + 1]
                                                .text
                                                .isEmpty) {
                                          FocusScope.of(context).requestFocus(
                                              _focusNodes[index - 1]);
                                        }
                                      }

                                      // Todo : Auto Enter next container
                                      if (value.isNotEmpty) {
                                        if (index < _focusNodes.length - 1) {
                                          FocusScope.of(context).requestFocus(
                                              _focusNodes[index + 1]);
                                        }
                                        // else {
                                        //   FocusScope.of(context).unfocus();
                                        // }
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _timeLeft > 0
                                ? Text(
                                    "Resend code in ${formatTime(_timeLeft)}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      bloc.add(SendCode(
                                          userEmail: widget.emailAddress));
                                      _startTimer();
                                    },
                                    child: const Text(
                                      "Resend Verification Code",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (codeDigits.isNotEmpty) {
                                    bloc.add(CodeSubmitted());
                                  }
                                },
                                // style: ButtonStyles.formSubmitButtonStyle,
                                child: const Text(
                                  "Confirm Code",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Change Email'))
                          ],
                        )),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//
// class EmailVerificationScreen extends StatefulWidget {
//   final String emailAddress;
//   const EmailVerificationScreen({super.key, required this.emailAddress});
//
//   @override
//   EmailVerificationScreenState createState() =>
//       EmailVerificationScreenState();
// }
//
// class EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   final List<TextEditingController> _controllers =
//       List.generate(6, (_) => TextEditingController());
//
//   // Method to handle input and automatically move to the next field
//   void _onCodeEntered(int index, String value) {
//     if (value.isNotEmpty) {
//       if (index < _focusNodes.length - 1) {
//         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//       } else {
//         FocusScope.of(context).unfocus(); // Unfocus on the last field
//       }
//     }
//   }
//
//   // Method to handle backspace logic
//   void _onBackspacePressed(int index) {
//     FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     _controllers[index - 1].clear();
//   }
//
//   // Method to validate and submit the verification code
//   void _submitCode() {
//     if (_formKey.currentState!.validate()) {
//       final code = _controllers.map((controller) => controller.text).join();
//       print('Verification code entered: $code');
//       // Proceed with code confirmation logic
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => const DobGen()));
//     }
//   }
//
//   @override
//   void dispose() {
//     _controllers.forEach((controller) => controller.dispose());
//     _focusNodes.forEach((focusNode) => focusNode.dispose());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double boxHeight = deviceHeight / 3; // Divide height by 3
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Email Verification")),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: boxHeight * 0.1,
//               ),
//               SizedBox(
//                   // color: Colors.green,
//                   width: 150,
//                   height: 130,
//                   child: Lottie.asset('assets/email verification.json',
//                       fit: BoxFit.cover)),
//               const Text(
//                 "Please verify you account",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 'We send verification code to ${widget.emailAddress}. Please check your index and enter the code below.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(6, (index) {
//                   return Container(
//                     width: MediaQuery.of(context).size.height * 0.09 - 30,
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     child: TextFormField(
//                       controller: _controllers[index],
//                       focusNode: _focusNodes[index],
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       maxLength: 1,
//                       cursorColor: isDarkTheme ? Colors.white : Colors.blue,
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                       decoration: InputDecoration(
//                         counterText: "",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[400]!),
//                         ),
//                         filled: true,
//                         fillColor: isDarkTheme ? Colors.grey : Colors.grey[100],
//                       ),
//                       onChanged: (value) => _onCodeEntered(index, value),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return '';
//                         }
//                         return null;
//                       },
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: 300,
//                 child: ElevatedButton(
//                   onPressed: _submitCode,
//                   style: ButtonStyles.formSubmitButtonStyle,
//                   child: const Text(
//                     "Confirm Code",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
