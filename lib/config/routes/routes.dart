import 'package:flutter/material.dart';
import 'package:telx/bloc/Sign%20Up%20Process/SignupCubit/signup_cubit.dart';
import 'package:telx/bloc/Sign%20Up%20Process/email_verification/email_verification_bloc.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_screens.dart';
import 'package:telx/presentation/screens/AuthScreen/splash_screen.dart';
import 'package:telx/presentation/screens/Home/home_screen.dart';
import 'package:telx/presentation/screens/Login/login_screen.dart';
import 'package:telx/presentation/screens/SignUp/email_verification_Screen.dart';
import 'package:telx/presentation/screens/SignUp/signup_screen.dart';
import 'package:telx/presentation/screens/SignUp/user_form_screen.dart';
import 'package:telx/presentation/screens/SignUp/verify_code_screen.dart';
import 'package:telx/presentation/screens/no_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      // case RoutesNames.splashScreen:
      //   return MaterialPageRoute(builder: (context) => const SplashScreen());

      case RoutesNames.authScreen:
        return MaterialPageRoute(builder: (context) => const AuthScreens());

      case RoutesNames.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case RoutesNames.signupScreen:
        return MaterialPageRoute(builder: (context) => const SignupScreen());

      case RoutesNames.emailVerificationScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['emailAddress']) {
          final emailAddress = args['emailAddress'] as String;
          return MaterialPageRoute(
              builder: (context) =>
                  EmailVerificationScreen(emailAddress: emailAddress));
        }
        return MaterialPageRoute(builder: (context) => const NoScreen());

      case RoutesNames.verifyCodeScreen:
        return MaterialPageRoute(
            builder: (context) => const VerifyCodeScreen());

      case RoutesNames.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case RoutesNames.userInfoDetailsScreen:
        return MaterialPageRoute(
            builder: (context) => const UserInfoFormScreen());
      default:
        return MaterialPageRoute(builder: (context) => const NoScreen());
    }
  }
}
