import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/auth/Auth%20Screen/auth_screen_bloc.dart';
import 'package:telx/bloc/auth/login/login_bloc.dart';
import 'package:telx/presentation/widgets/google_button.dart';
import 'package:telx/presentation/widgets/custom_input_field_decorator.dart';
import 'package:telx/utils/device_utils.dart';
import 'package:telx/presentation/widgets/snack_bar_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNodeEmail = FocusNode();

  final FocusNode _focusNodePassword = FocusNode();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(LoginSubmitted(
          email: emailController.text, password: passwordController.text));
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Main build");
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxHeight = deviceHeight / 3;
    bool isMobile = DeviceUtils.isMobile();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Align(
          alignment: isMobile ? Alignment.center : Alignment.topCenter,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: LayoutBuilder(builder: (context, constraints) {
                    double formSize;
                    if (constraints.maxWidth < 600) {
                      formSize = double.infinity;
                    } else {
                      formSize = 500;
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isMobile)
                          SizedBox(
                            height: boxHeight * 0.1,
                          ),

                        // Todo: Logo
                        const Text(
                          "TelX",
                          style: TextStyle(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        ),

                        const Text(
                          "Welcome, Please enter your details",
                          style: TextStyle(fontSize: 18),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // Todo: User Email
                        SizedBox(
                          width: formSize,
                          child: TextFormField(
                            focusNode: _focusNodeEmail,
                            onFieldSubmitted: (value) {
                              _submit(context);
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: customInputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter you email',
                                context: context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Todo: User Password
                        BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (previous, current) {
                            // Rebuild only when the password visibility toggles or the state changes
                            if (current is PasswordVisibilityState &&
                                previous is PasswordVisibilityState) {
                              return current.isPasswordVisible !=
                                  previous.isPasswordVisible;
                            }
                            // Ensure a new state triggers a rebuild
                            return previous != current;
                          },
                          builder: (context, state) {
                            print("Password visibility");
                            final isPasswordVisible =
                                state is PasswordVisibilityState
                                    ? state.isPasswordVisible
                                    : false;

                            return SizedBox(
                              width: formSize,
                              child: TextFormField(
                                focusNode: _focusNodePassword,
                                onFieldSubmitted: (value) {
                                  _submit(context);
                                },
                                obscureText: !isPasswordVisible,
                                // controller: passwordController,
                                decoration: customInputDecoration(
                                  labelText: "Password",
                                  hintText: "Enter you password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(TogglePasswordVisibility());
                                    },
                                  ),

                                  context: context,
                                ),
                                // onChanged: ,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Todo: Forgot Password
                        SizedBox(
                            width: formSize,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ))),
                        const SizedBox(
                          height: 15,
                        ),

                        // Todo: Login Button
                        SizedBox(
                          width: formSize,
                          height: 50,
                          child: ElevatedButton(
                              // style: ButtonStyles.formSubmitButtonStyle,
                              onPressed: () => _submit(context),
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // Todo: Check Account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  context
                                      .read<AuthScreenBloc>()
                                      .add(SwitchToSignup());
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                                },
                                child: const Text(
                                  'Sign Up',
                                )),
                          ],
                        ),

                        // Todo: "or" Text with Horizontal Lines
                        const SizedBox(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey, // Line color
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "or",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      // "or" text color
                                      fontWeight: FontWeight
                                          .w600, // Optional: makes "or" bold
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey, // Line color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Todo: Google Button
                        GoogleButtonWidget(formSize: formSize)
                      ],
                    );
                  })),
            ),
          ),
          // BlocConsumer<LoginBloc, LoginState>(
          //   listener: (context, state) {
          //     if (state is LoginSuccess) {
          //       showCustomSnackBar(
          //           context: context,
          //           message: 'Login Successful!',
          //           type: SnackBarType.success);
          //     } else if (state is LoginLoading) {
          //       showCustomSnackBar(
          //           context: context,
          //           message: 'Is loading...',
          //           type: SnackBarType.loading);
          //     } else if (state is LoginFailure) {
          //       showCustomSnackBar(
          //           context: context,
          //           message: state.error,
          //           type: SnackBarType.failure);
          //     }
          //   },
          //   builder: (context, state) {
          //     bool isPasswordVisible = state is PasswordVisibilityState
          //         ? state.isPasswordVisible
          //         : false;
          //
          //     print("BlocBuilder build");
          //     if (state is LoginLoading) {
          //       return const Center(
          //         child: CircularProgressIndicator(
          //           color: Colors.grey,
          //         ),
          //       );
          //     } else if (state is PasswordVisibilityState) {
          //       isPasswordVisible = state.isPasswordVisible;
          //     }
          //     return SingleChildScrollView(
          //       child: Form(
          //         key: _formKey,
          //         child: Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 8, vertical: 16),
          //             child: LayoutBuilder(builder: (context, constraints) {
          //               double formSize;
          //               if (constraints.maxWidth < 600) {
          //                 formSize = double.infinity;
          //               } else {
          //                 formSize = 500;
          //               }
          //               return Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   if (!isMobile)
          //                     SizedBox(
          //                       height: boxHeight * 0.1,
          //                     ),
          //
          //                   // Todo: Logo
          //                   const Text(
          //                     "TelX",
          //                     style: TextStyle(
          //                         fontSize: 70, fontWeight: FontWeight.bold),
          //                   ),
          //
          //                   const Text(
          //                     "Welcome, Please enter your details",
          //                     style: TextStyle(fontSize: 18),
          //                   ),
          //
          //                   const SizedBox(
          //                     height: 20,
          //                   ),
          //
          //                   // Todo: User Email
          //                   SizedBox(
          //                     width: formSize,
          //                     child: TextFormField(
          //                       focusNode: _focusNodeEmail,
          //                       onFieldSubmitted: (value) {
          //                         _submit(context);
          //                       },
          //                       controller: emailController,
          //                       keyboardType: TextInputType.emailAddress,
          //                       decoration: customInputDecoration(
          //                           labelText: 'Email',
          //                           hintText: 'Enter you email',
          //                           context: context),
          //                       validator: (value) {
          //                         if (value == null || value.isEmpty) {
          //                           return 'Please enter your email';
          //                         } else if (!RegExp(
          //                                 r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
          //                             .hasMatch(value)) {
          //                           return 'Please enter a valid email';
          //                         }
          //                         return null;
          //                       },
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //
          //                   // Todo: User Password
          //                   SizedBox(
          //                     width: formSize,
          //                     child: TextFormField(
          //                       focusNode: _focusNodePassword,
          //                       onFieldSubmitted: (value) {
          //                         _submit(context);
          //                       },
          //                       obscureText: !isPasswordVisible,
          //                       controller: passwordController,
          //                       decoration: customInputDecoration(
          //                         labelText: "Password",
          //                         hintText: "Enter you password",
          //                         suffixIcon: IconButton(
          //                           icon: Icon(
          //                             isPasswordVisible
          //                                 ? Icons.visibility
          //                                 : Icons.visibility_off,
          //                           ),
          //                           onPressed: () {
          //                             context
          //                                 .read<LoginBloc>()
          //                                 .add(TogglePasswordVisibility());
          //                           },
          //                         ),
          //                         context: context,
          //                       ),
          //                       validator: (value) {
          //                         if (value == null || value.isEmpty) {
          //                           return 'Please enter your password';
          //                         }
          //                         return null;
          //                       },
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //
          //                   // Todo: Forgot Password
          //                   SizedBox(
          //                       width: formSize,
          //                       child: Align(
          //                           alignment: Alignment.centerRight,
          //                           child: InkWell(
          //                             onTap: () {},
          //                             child: const Text(
          //                               'Forgot password?',
          //                               style: TextStyle(color: Colors.blue),
          //                             ),
          //                           ))),
          //                   const SizedBox(
          //                     height: 15,
          //                   ),
          //
          //                   // Todo: Login Button
          //                   SizedBox(
          //                     width: formSize,
          //                     height: 50,
          //                     child: ElevatedButton(
          //                         // style: ButtonStyles.formSubmitButtonStyle,
          //                         onPressed: () => _submit(context),
          //                         child: const Text(
          //                           "Login",
          //                           style: TextStyle(color: Colors.white),
          //                         )),
          //                   ),
          //
          //                   const SizedBox(
          //                     height: 20,
          //                   ),
          //
          //                   // Todo: Check Account
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Text("Don't have an account?"),
          //                       TextButton(
          //                           onPressed: () {
          //                             context
          //                                 .read<AuthScreenBloc>()
          //                                 .add(SwitchToSignup());
          //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
          //                           },
          //                           child: const Text(
          //                             'Sign Up',
          //                           )),
          //                     ],
          //                   ),
          //
          //                   // Todo: "or" Text with Horizontal Lines
          //                   const SizedBox(
          //                     width: 200,
          //                     child: Padding(
          //                       padding: EdgeInsets.symmetric(vertical: 30),
          //                       child: Row(
          //                         children: [
          //                           Expanded(
          //                             child: Divider(
          //                               thickness: 1,
          //                               color: Colors.grey, // Line color
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding:
          //                                 EdgeInsets.symmetric(horizontal: 10),
          //                             child: Text(
          //                               "or",
          //                               style: TextStyle(
          //                                 fontSize: 16,
          //                                 color: Colors.grey,
          //                                 // "or" text color
          //                                 fontWeight: FontWeight
          //                                     .w600, // Optional: makes "or" bold
          //                               ),
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: Divider(
          //                               thickness: 1,
          //                               color: Colors.grey, // Line color
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //
          //                   // Todo: Google Button
          //                   GoogleButtonWidget(formSize: formSize)
          //                 ],
          //               );
          //             })),
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
