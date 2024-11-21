import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Sign%20Up%20Process/signup/signup_bloc.dart';
import 'package:telx/bloc/Theme%20Management/them_cubit.dart';
import 'package:telx/bloc/auth/google/google_button_bloc.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_screens.dart';
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

  final themeMode = await ThemeManager.loadThemeMode();

  runApp(MyApp(
    themeMode: themeMode,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;

  const MyApp({super.key, required this.themeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => SignupBloc()),
          BlocProvider(create: (context) => GoogleButtonBloc()),
          BlocProvider(create: (context) => ThemeCubit()),
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
              home: const AuthScreens(),
            );
          },
        ));
  }
}
