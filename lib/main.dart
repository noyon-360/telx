import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Theme%20Management/them_cubit.dart';
import 'package:telx/bloc/auth/LoginCubit/login_cubit.dart';
import 'package:telx/bloc/auth/google_cubit/google_cubit.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_switch_cubit.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/services/theme_manager.dart';
import 'bloc/Theme Management/them_state.dart';
import 'bloc/auth/Sign Up Process/SignupCubit/signup_cubit.dart';
import 'bloc/auth/Sign Up Process/email_verification/verify_code_cubit.dart';
import 'bloc/auth/Sign Up Process/user_info_cubit/user_info_form_cubit.dart';
import 'bloc/loading_page/loading_cubit.dart';
import 'data/theme/light_dark_theme.dart';
import 'private/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  final themeMode = await ThemeManager.loadThemeMode();

  runApp(MyApp(
    themeMode: themeMode,
    authenticationRepository: authenticationRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;

  const MyApp({super.key, required this.themeMode, required AuthenticationRepository authenticationRepository,}) : _authenticationRepository = authenticationRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(lazy: false, create: (context) => ThemeCubit()),
          BlocProvider(lazy: false, create: (context) => LoadingCubit()),
          BlocProvider(lazy: false, create: (context) => AuthSwitchCubit()),
          BlocProvider(lazy: false, create: (context) => SignUpCubit(_authenticationRepository)),
          BlocProvider(lazy: false, create: (context) => LoginCubit(_authenticationRepository)),
          BlocProvider(lazy: false, create: (context) => GoogleCubit(_authenticationRepository)),
          BlocProvider(lazy: false, create: (context) => UserInfoFormCubit(_authenticationRepository)),
          BlocProvider(lazy: false, create: (context) => VerifyCodeCubit(_authenticationRepository)..startTimer()),
        ],
        child: BlocBuilder<ThemeCubit, AppTheme>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'TelX',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: state == AppTheme.light ? ThemeMode.light : ThemeMode.dark,
              initialRoute: RoutesNames.splashScreen,
              onGenerateRoute: Routes.generateRoutes,
            );
          },
        ));
  }
}
