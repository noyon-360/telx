import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Sign%20Up%20Process/SignupCubit/signup_cubit.dart';
import 'package:telx/bloc/Sign%20Up%20Process/email_verification/verify_code_cubit.dart';
import 'package:telx/bloc/Sign%20Up%20Process/signup/signup_bloc.dart';
import 'package:telx/bloc/Sign%20Up%20Process/user_info_cubit/user_info_form_cubit.dart';
import 'package:telx/bloc/Theme%20Management/them_cubit.dart';
import 'package:telx/bloc/auth/LoginCubit/login_cubit.dart';
import 'package:telx/bloc/auth/google/google_button_bloc.dart';
import 'package:telx/config/routes/routes.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_screens.dart';
import 'package:telx/presentation/screens/SignUp/user_form_screen.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/services/theme_manager.dart';

import 'bloc/Theme Management/them_state.dart';
import 'bloc/auth/login/login_bloc.dart';
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

  const MyApp({
    super.key,
    required this.themeMode,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;
  final AuthenticationRepository _authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SignUpCubit(_authenticationRepository)),
          BlocProvider(
              lazy: false,
              create: (context) => LoginCubit(_authenticationRepository)),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => LoginCubit(_authenticationRepository)),
          BlocProvider(create: (context) => SignUpCubit(_authenticationRepository)),
          BlocProvider(create: (context) => GoogleButtonBloc()),
          BlocProvider(create: (context) => UserInfoFormCubit(_authenticationRepository)),
          BlocProvider(
              create: (context) =>
                  VerifyCodeCubit(_authenticationRepository)..startTimer()),
        ],
        child: BlocBuilder<ThemeCubit, AppTheme>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'TelX',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode:
                  state == AppTheme.light ? ThemeMode.light : ThemeMode.dark,
              initialRoute: RoutesNames.authScreen,
              onGenerateRoute: Routes.generateRoutes,
            );
          },
        ));
  }
}
