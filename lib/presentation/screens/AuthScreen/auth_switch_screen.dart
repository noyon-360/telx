import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_switch_cubit.dart';
import 'package:telx/presentation/screens/Login/login_view_link.dart';
import 'package:telx/presentation/screens/SignUp/signup_view_link.dart';

class AuthSwitchScreen extends StatelessWidget {
  const AuthSwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSwitchCubit, AuthScreenState>(builder: (context, state) {
      switch (state) {
        case AuthScreenState.signup:
          return const SignupScreen();
        case AuthScreenState.login:
          return const LoginScreen();
        default :
          return const LoginScreen();
      }
    });
  }
}
