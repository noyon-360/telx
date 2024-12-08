part of 'login_view_link.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceUtils.isMobile();
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double boxHeight = deviceHeight / 3;

    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.inProgress) {
                  context.read<LoadingCubit>().startLoading();
                } else {
                  context.read<LoadingCubit>().stopLoading();
                }
              },
              child: Scaffold(
                body: Align(
                  alignment: isMobile ? Alignment.center : Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double formSize =
                            constraints.maxWidth < 600 ? double.infinity : 500;
                        return SizedBox(
                          width: formSize,
                          child: Form(
                            // key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!isMobile)
                                  SizedBox(height: boxHeight * 0.1),
                                const LogoSection(subtitle: "Welcome, Please enter your details"),
                                EmailField(formSize: formSize),
                                const SizedBox(height: 10),
                                PasswordField(formSize: formSize),
                                const SizedBox(height: 10),
                                ForgotPassword(formSize: formSize),
                                const SizedBox(height: 15),
                                _LoginButton(formSize: formSize),
                                const SizedBox(height: 20),
                                const _SignUpSection(),
                                const SizedBox(height: 20),
                                const _DividerWithText(),
                                const SizedBox(height: 20),
                                GoogleButtonWidget(formSize: formSize),
                              ],
                            ),
                          ),
                        );
                      },
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
        ));
  }
}

class EmailField extends StatelessWidget {
  final double formSize;

  const EmailField({super.key, required this.formSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: formSize,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: customInputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          context: context,
        ),
        onChanged: (value) {
          context.read<LoginCubit>().emailChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final double formSize;

  const PasswordField({super.key, required this.formSize});

  @override
  Widget build(BuildContext context) {
    final passwordVisibility =
        context.select((LoginCubit cubit) => cubit.state.passwordVisibility);
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
        ),
        onChanged: (value) {
          context.read<LoginCubit>().passwordChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  final double formSize;

  const ForgotPassword({super.key, required this.formSize});

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
    // final cubit = context.select((LoginCubit cubit) => cubit);

    // final isInProgress = context.select(
    //   (LoginCubit cubit) => cubit.state.status.isInProgress,
    // );

    // if (cubit.state.status.isInProgress) {
    //   return const CircularProgressIndicator();
    // }
    final cubit = context.read<LoginCubit>();
    // final isValid = context.select(
    //   (LoginCubit cubit) => cubit.state.isValid,
    // );
    return SizedBox(
      width: formSize,
      height: 50,
      child: ElevatedButton(
        // key: const Key('loginForm_continue_raisedButton'),
        onPressed: () {
          cubit.logInWithCredentials(context);
        },
        // cubit.state.isValid
        //     ? () => context.read<LoginCubit>().logInWithCredentials(context)
        //     : () => showCustomSnackBar(
        //         context: context,
        //         message: 'Field is not valid',
        //         type: SnackBarType.failure),
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
            context.read<AuthSwitchCubit>().switchSignupScreen();
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   RoutesNames.signupScreen,
            //   (route) => false,
            // );
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
