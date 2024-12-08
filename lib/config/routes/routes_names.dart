import 'package:flutter/material.dart';
import 'package:telx/presentation/screens/Home/home_screen.dart';
import 'package:telx/presentation/screens/no_screen.dart';

import '../../presentation/screens/AuthScreen/auth_switch_screen.dart';
import '../../presentation/screens/AuthScreen/splash_screen.dart';
import '../../presentation/screens/Login/login_view_link.dart';
import '../../presentation/screens/SignUp/signup_view_link.dart';
import '../../repositories/authentication_repository.dart';


part 'routes.dart';

class RoutesNames {
  static const String splashScreen = 'splash_screen';
  static const String authSwitchScreen = 'auth_switch_screen';
  static const String loginScreen = 'login_screen';
  static const String signupScreen = 'signup_screen';
  static const String emailVerificationScreen = 'email_verification_screen';
  static const String verifyCodeScreen = 'verify_code_screen';
  static const String userInfoDetailsScreen = 'user_info_details_screen';
  static const String homeScreen = 'home_screen';
}