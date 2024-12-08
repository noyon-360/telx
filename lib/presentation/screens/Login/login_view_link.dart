import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/loading_page/loading_cubit.dart';
// import 'package:formz/formz.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/presentation/screens/AuthScreen/auth_switch_cubit.dart';
import 'package:telx/presentation/widgets/loading_screen.dart';
import 'package:telx/presentation/widgets/snack_bar_helper.dart';

import '../../../bloc/auth/LoginCubit/login_cubit.dart';
import '../../../utils/device_utils.dart';
import '../../widgets/custom_input_field_decorator.dart';
import '../../widgets/google_button.dart';
import '../../widgets/logo_section.dart';

part 'login_screen.dart';
