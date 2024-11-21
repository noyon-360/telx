import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Sign%20Up%20Process/signup/signup_bloc.dart';
import 'package:telx/bloc/auth/Auth%20Screen/auth_screen_bloc.dart';
import 'package:telx/presentation/screens/SignUp/email_verification_Screen.dart';
import 'package:telx/presentation/widgets/google_button.dart';
import 'package:telx/presentation/widgets/custom_input_field_decorator.dart';
import 'package:telx/utils/device_utils.dart';
import 'package:telx/presentation/widgets/snack_bar_helper.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignupScreen({super.key});

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(SignupSubmit(
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text));
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Align(
          alignment: isMobile ? Alignment.center : Alignment.topCenter,
          child:
              BlocConsumer<SignupBloc, SignupState>(builder: (context, state) {
            bool isPasswordVisible = false;
            bool isConfirmPasswordVisible = false;
            print("Building");

            if (state is SignupLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              );
            }
            if (state is PasswordVisibilityState) {
              print("PasswordVisibilityState");
              isPasswordVisible = state.isPasswordVisible;
            }

            if (state is ConfirmPasswordVisibilityState) {
              print("ConfirmPasswordVisibilityState");
              isConfirmPasswordVisible = state.isConfirmPasswordVisible;
            }
            return SingleChildScrollView(
                child: LayoutBuilder(builder: (context, constraints) {
              double formSize;
              if (constraints.maxWidth < 600) {
                formSize = double.infinity;
              } else {
                formSize = 500;
              }

              return _form(context, formSize, isPasswordVisible,
                  isConfirmPasswordVisible, isMobile);
            }));
          }, listener: (context, state) {
            if (state is SignupSuccess) {
              showCustomSnackBar(
                  context: context,
                  message: 'Login Successful!',
                  type: SnackBarType.success);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmailVerificationScreen(
                            emailAddress: emailController.text,
                          )));
            } else if (state is SignupLoading) {
              showCustomSnackBar(
                  context: context,
                  message: 'Is loading...',
                  type: SnackBarType.loading);
            } else if (state is SignupFailure) {
              showCustomSnackBar(
                  context: context,
                  message: state.error,
                  type: SnackBarType.failure);
            }
          }),
        ),
      ),
    );
  }

  Widget _form(BuildContext context, double formSize, bool isPasswordVisible,
      bool isConfirmPasswordVisible, bool isMobile) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxHeight = deviceHeight / 3;
    return Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
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
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              ),

              const Text(
                "Create your account",
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
                    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
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
              SizedBox(
                width: formSize,
                child: TextFormField(
                  focusNode: _focusNodePassword,
                  onFieldSubmitted: (value) {
                    _submit(context);
                  },
                  obscureText: !isPasswordVisible,
                  controller: passwordController,
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
                            .read<SignupBloc>()
                            .add(TogglePasswordVisibility());
                      },
                    ),
                    context: context,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Todo: Confirm Password
              SizedBox(
                width: formSize,
                child: TextFormField(
                  focusNode: _focusNodeConfirmPassword,
                  onFieldSubmitted: (value) {
                    _submit(context);
                  },
                  obscureText: !isConfirmPasswordVisible,
                  controller: confirmPasswordController,
                  decoration: customInputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Re-enter you password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        context
                            .read<SignupBloc>()
                            .add(ToggleConfirmPasswordVisibility());
                      },
                    ),
                    context: context,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value != passwordController.text) {
                      return 'Password not match';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // Todo: Continue Button
              SizedBox(
                width: formSize,
                height: 50,
                child: ElevatedButton(
                    // style: ButtonStyles.formSubmitButtonStyle,
                    onPressed: () => _submit(context),
                    child: const Text(
                      "Continue",
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
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        context.read<AuthScreenBloc>().add(SwitchToLogin());
                      },
                      child: const Text(
                        'Login',
                      )),
                ],
              ),

              // "or" Text with Horizontal Lines
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
                            color: Colors.grey, // "or" text color
                            fontWeight:
                                FontWeight.w600, // Optional: makes "or" bold
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
          )),
    );
  }
}
