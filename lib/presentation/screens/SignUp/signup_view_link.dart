import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:telx/bloc/loading_page/loading_cubit.dart';
import 'package:telx/data/theme/color.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_switch_cubit.dart';

import '../../../bloc/auth/Sign Up Process/SignupCubit/signup_cubit.dart';
import '../../../bloc/auth/Sign Up Process/email_verification/verify_code_cubit.dart';
import '../../../bloc/auth/Sign Up Process/user_info_cubit/user_info_form_cubit.dart';
import '../../../config/routes/routes_names.dart';
import '../../../utils/device_utils.dart';
import '../../widgets/custom_input_field_decorator.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/google_button.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/logo_section.dart';
import '../../widgets/snack_bar_helper.dart';

part 'verify_code_screen.dart';
part 'user_form_screen.dart';
part 'signup_screen.dart';
part 'password_strength.dart';
