part of 'routes_names.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final  authRepository = AuthenticationRepository();
    switch (settings.name) {
      case RoutesNames.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen(authRepository : authRepository,));

      case RoutesNames.authSwitchScreen:
        return MaterialPageRoute(builder: (context) => const AuthSwitchScreen());

      case RoutesNames.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case RoutesNames.signupScreen:
        return MaterialPageRoute(builder: (context) => const SignupScreen());

      case RoutesNames.verifyCodeScreen:
        return MaterialPageRoute(builder: (context) => const VerifyCodeScreen());

      case RoutesNames.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen(authRepository: authRepository,));

      case RoutesNames.userInfoDetailsScreen:
        return MaterialPageRoute(builder: (context) => const UserInfoFormScreen());

      default:
        return MaterialPageRoute(builder: (context) => const NoScreen());
    }
  }
}
