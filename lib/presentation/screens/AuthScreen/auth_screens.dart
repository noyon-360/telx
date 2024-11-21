import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/auth/Auth%20Screen/auth_screen_bloc.dart';
import 'package:telx/presentation/screens/Login/login_screen.dart';
import 'package:telx/presentation/screens/SignUp/signup_screen.dart';

class AuthScreens extends StatelessWidget {
  const AuthScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthScreenBloc(),
      child: BlocBuilder<AuthScreenBloc, AuthScreenState>(
          builder: (context, state) {
        if (state is LoginScreenState) {
          return LoginScreen();
        } else if (state is SignupScreenState) {
          return SignupScreen();
        }
        return LoginScreen();
      }),
    );
  }
}
