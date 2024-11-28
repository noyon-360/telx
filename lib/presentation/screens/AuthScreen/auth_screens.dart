// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/auth/Auth%20Screen/auth_screen_bloc.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/presentation/screens/Home/home_screen.dart';
import 'package:telx/presentation/screens/Login/login_screen.dart';
import 'package:telx/presentation/screens/SignUp/signup_screen.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/src/models/user.dart';

class AuthScreens extends StatelessWidget {
  const AuthScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthenticationRepository();
    authRepository.user.listen((user) {
      if (user != User.empty) {
        // If user is authenticated, navigate to HomePage
        Navigator.pushReplacementNamed(context, RoutesNames.homeScreen);
      } else {
        // If user is not authenticated, navigate to LoginPage
        Navigator.pushReplacementNamed(context, RoutesNames.loginScreen);

      }
    });
    return BlocProvider(
      create: (context) => AuthScreenBloc(),
      child: BlocBuilder<AuthScreenBloc, AuthScreenState>(
          builder: (context, state) {
            if( state is LoadingState){
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is LoginScreenState) {
              return const LoginScreen();
            } else if (state is SignupScreenState) {
              return const SignupScreen();
            }
            return const LoginScreen();
          }),
    );
  }
}
