import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:telx/bloc/auth/Auth%20Screen/auth_screen_bloc.dart';
import 'package:telx/bloc/auth/LoginCubit/login_cubit.dart';

// import 'package:telx/bloc/auth/login/login_bloc.dart';
// import 'package:telx/bloc/auth/login/login_bloc.dart';
import 'package:telx/presentation/widgets/google_button.dart';
import 'package:telx/presentation/widgets/custom_input_field_decorator.dart';
import 'package:telx/presentation/widgets/logo_section.dart';
import 'package:telx/utils/device_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceUtils.isMobile();
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double boxHeight = deviceHeight / 3;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state.status.isSuccess) {

        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Align(
            alignment: isMobile ? Alignment.center : Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double formSize = constraints.maxWidth < 600
                      ? double.infinity
                      : 500; // Cache calculated values

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isMobile) SizedBox(height: boxHeight * 0.1),
                      const LogoSection(
                          subtitle: "Welcome, Please enter your details"),
                      _EmailField(formSize: formSize),
                      const SizedBox(height: 10),
                      _PasswordField(
                        formSize: formSize,
                      ),
                      const SizedBox(height: 10),
                      _ForgotPassword(formSize: formSize),
                      const SizedBox(height: 15),
                      _LoginButton(formSize: formSize),
                      const SizedBox(height: 20),
                      const _SignUpSection(),
                      const SizedBox(height: 20),
                      const _DividerWithText(),
                      const SizedBox(height: 20),
                      GoogleButtonWidget(formSize: formSize),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _LogoSection extends StatelessWidget {
//   const _LogoSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         Text(
//           "TelX",
//           style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           "Welcome, Please enter your details",
//           style: TextStyle(fontSize: 18),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }
// }

class _EmailField extends StatelessWidget {
  final double formSize;

  const _EmailField({required this.formSize});

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );
    print("Email printing");
    return SizedBox(
      width: formSize,
      child: TextFormField(
        // controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: customInputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          context: context,
        ).copyWith(
          errorText: displayError != null ? 'invalid email' : null,
        ),
        onChanged: (value) {
          context.read<LoginCubit>().emailChanged(value);
        },
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final double formSize;

  const _PasswordField({required this.formSize});

  @override
  Widget build(BuildContext context) {
    final passwordVisibility =
        context.select((LoginCubit cubit) => cubit.state.passwordVisibility);
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );
    return SizedBox(
      width: formSize,
      child: TextFormField(
        obscureText: !passwordVisibility,
        decoration: customInputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisibility ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => context.read<LoginCubit>().toggleObscureText(),
          ),
          context: context,
        ).copyWith(
          errorText: displayError?.toString(),
        ),
        onChanged: (value) {
          context.read<LoginCubit>().passwordChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  final double formSize;

  const _ForgotPassword({required this.formSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: formSize,
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {},
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final double formSize;

  const _LoginButton({required this.formSize});

  @override
  Widget build(BuildContext context) {
    final cubit = context.select(
            (LoginCubit cubit) => cubit);


    // final isInProgress = context.select(
    //   (LoginCubit cubit) => cubit.state.status.isInProgress,
    // );

    if (cubit.state.status.isInProgress) return const CircularProgressIndicator();

    // final isValid = context.select(
    //   (LoginCubit cubit) => cubit.state.isValid,
    // );
    return SizedBox(
      width: formSize,
      height: 50,
      child: ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        onPressed: cubit.state.isValid
            ? () => context.read<LoginCubit>().logInWithCredentials(context)
            : null,
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _SignUpSection extends StatelessWidget {
  const _SignUpSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            context.read<AuthScreenBloc>().add(SwitchToSignup());
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "or",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }
}
