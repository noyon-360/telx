part of "signup_view_link.dart";

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceUtils.isMobile();
    final double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    final double boxHeight = deviceHeight / 3;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            BlocListener<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state.status == SignupStatus.inProgress) {
                  context.read<LoadingCubit>().startLoading();
                } else if (state.status == SignupStatus.success) {
                  Navigator.pushNamed(context, RoutesNames.verifyCodeScreen);
                  context.read<LoadingCubit>().stopLoading();
                } else if (state.status == SignupStatus.failure) {
                  showCustomSnackBar(
                      context: context,
                      message: 'Signup Failure',
                      type: SnackBarType.failure);
                  context.read<LoadingCubit>().stopLoading();
                } else if (state.emailExist) {
                  showCustomSnackBar(
                      context: context,
                      message: 'Email is exist',
                      type: SnackBarType.info);
                } else {
                  context.read<LoadingCubit>().stopLoading();
                }
              },
              child: Scaffold(
                body: Align(
                  alignment: isMobile ? Alignment.center : Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double formSize = constraints.maxWidth < 600
                            ? double.infinity
                            : 500; // Cache calculated values

                        return Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isMobile) SizedBox(height: boxHeight * 0.1),
                              const LogoSection(
                                  subtitle: "Welcome, Please enter your details"),
                              _EmailField(formSize: formSize),
                              const SizedBox(height: 10),
                              _PasswordField(formSize: formSize),
                              const SizedBox(height: 10),
                              _ConfirmPasswordField(formSize: formSize),
                              const SizedBox(height: 15),
                              _ContinueButton(formSize: formSize),
                              const SizedBox(height: 20),
                              const _LoginSection(),
                              const SizedBox(height: 20),
                              const _DividerWithText(),
                              const SizedBox(height: 20),
                              GoogleButtonWidget(formSize: formSize),
                            ],
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
        )

    );
  }
}

class _EmailField extends StatelessWidget {
  final double formSize;

  const _EmailField({required this.formSize});

  @override
  Widget build(BuildContext context) {
    bool isSubmitted =
    context.select((SignUpCubit cubit) => cubit.state.isSubmitted);
    final email = context.select((SignUpCubit cubit) => cubit.state.email);
    // final displayError = context.select(
    //       (SignUpCubit cubit) => cubit.state.email.displayError,
    // );
    return SizedBox(
      width: formSize,
      child: TextFormField(
        // key: const Key('signUpForm_emailInput_textField'),
        keyboardType: TextInputType.emailAddress,
        decoration: customInputDecoration(
            labelText: 'Email', hintText: 'Enter you email', context: context),
        onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final double formSize;

  const _PasswordField({required this.formSize});

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible =
    context.select((SignUpCubit cubit) => cubit.state.passwordVisibility);
    final isSubmitted =
    context.select((SignUpCubit cubit) => cubit.state.isSubmitted);
    final password =
    context.select((SignUpCubit cubit) => cubit.state.password);
    return SizedBox(
      width: formSize,
      child: Column(
        children: [
          TextFormField(
            obscureText: !isPasswordVisible,
            decoration: customInputDecoration(
              labelText: "Password",
              hintText: "Enter you password",
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  context.read<SignUpCubit>().togglePasswordVisibility();
                },
              ),
              context: context,
            ),
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
          ),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              if (state.password.isNotEmpty) {
                if (state.password.length < 8) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Password must be at least 8 characters',
                        style: TextStyle(
                          // color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            showPasswordStrengthRules(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.info_outline),
                          ))
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: buildStrengthIndicator(state.passwordStrength),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mapStrengthToText(state.passwordStrength),
                        style: TextStyle(
                          color: mapStrengthToColor(state.passwordStrength),
                          fontSize: 16,
                        ),
                      ),
                      if (state.passwordStrength.index < 3)
                        InkWell(
                            onTap: () {
                              showPasswordStrengthRules(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.info_outline),
                            ))
                    ],
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final double formSize;

  const _ConfirmPasswordField({required this.formSize});

  @override
  Widget build(BuildContext context) {
    // final isConfirmPasswordVisibility = context
    //     .select((SignUpCubit cubit) => cubit.state.confirmPasswordVisibility);
    // final isSubmitted =
    //     context.select((SignUpCubit cubit) => cubit.state.isSubmitted);
    // final password = context.select(
    //     (SignUpCubit cubit) => cubit.state.confirmedPassword.displayError);
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          width: formSize,
          child: Column(
            children: [
              TextFormField(
                // key: const Key('signUpForm_confirmedPasswordInput_textField'),
                // focusNode: _focusNodeConfirmPassword,
                // onFieldSubmitted: (value) {
                //   _submit(context);
                // },
                obscureText: !state.confirmPasswordVisibility,
                // controller: confirmPasswordController,
                decoration: customInputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Re-enter you password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.confirmPasswordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      context
                          .read<SignUpCubit>()
                          .toggleConfirmPasswordVisibility();
                    },
                  ),
                  context: context,
                ),
                onChanged: (confirmPassword) =>
                    context
                        .read<SignUpCubit>()
                        .confirmedPasswordChanged(confirmPassword),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // if (value != passwordController.text) {
                  //   return 'Password not match';
                  // }
                  return null;
                },
              ),
              // Feedback Message
              (state.confirmedPassword.isNotEmpty)
                  ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.matchMessage!.toString(),
                  style: TextStyle(
                    color: state.matchPasswords
                        ? AppColors.success
                        : state.matchMessage == 'Matching so far...'
                        ? AppColors.warning
                        : AppColors.error,
                    fontSize: 14,
                  ),
                ),
              )
                  : const SizedBox.shrink()
              // if (state.confirmedPassword.value.isNotEmpty)
            ],
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final double formSize;

  const _ContinueButton({required this.formSize});

  @override
  Widget build(BuildContext context) {
    // final isInProgress = context.select(
    //   (SignUpCubit cubit) => cubit.state.status.isInProgress,
    // );

    // if (isInProgress) return const CircularProgressIndicator();
    //
    final isValid = context.select(
          (SignUpCubit cubit) => cubit.state.isValid,
    );

    final isValidState = context.select(
          (SignUpCubit cubit) => cubit.state,
    );
    return SizedBox(
      width: formSize,
      height: 50,
      child: ElevatedButton(
        // key: const Key('signUpForm_continue_raisedButton'),
        // style: ButtonStyles.formSubmitButtonStyle,
        // onPressed: () => _submit(context),
          onPressed: () {
            print("isValid : $isValid");
            print("Valid State: $isValidState");
            context.read<SignUpCubit>().continueToCreateAccount();
            // if (isValid) {
            // } else {
            //   print(isValid);
            // }
          },
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class _LoginSection extends StatelessWidget {
  const _LoginSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
            onPressed: () {
              context.read<AuthSwitchCubit>().switchLoginScreen();
              // Navigator.pop(context);
            },
            child: const Text(
              'Login',
            )),
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
