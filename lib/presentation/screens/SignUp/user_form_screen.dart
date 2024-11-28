import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telx/bloc/Sign%20Up%20Process/SignupCubit/signup_cubit.dart';
import 'package:telx/bloc/Sign%20Up%20Process/user_info_cubit/user_info_form_cubit.dart';
import 'package:telx/bloc/auth/LoginCubit/login_cubit.dart';
import 'package:telx/data/theme/color.dart';
import 'package:telx/presentation/widgets/custom_input_field_decorator.dart';
import 'package:telx/presentation/widgets/custom_loading.dart';
import 'package:telx/presentation/widgets/snack_bar_helper.dart';
import 'package:telx/utils/device_utils.dart';

class UserInfoFormScreen extends StatelessWidget {
  const UserInfoFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceUtils.isMobile();
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double boxHeight = deviceHeight / 3;

    print("Building........");

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<UserInfoFormCubit, UserInfoFormState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state.errorMessage != null) {
            showCustomSnackBar(
                context: context,
                message: state.errorMessage.toString(),
                type: SnackBarType.normal);
          }
        },
        child: Scaffold(
          body: Align(
            alignment: isMobile ? Alignment.center : Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double formSize = constraints.maxWidth < 600
                      ? double.infinity
                      : 500; // Cache calculated values

                  return SizedBox(
                    width: formSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isMobile) SizedBox(height: boxHeight * 0.1),
                        const LogoContainer(),
                        const FullNameWidget(),
                        const SizedBox(height: 16),
                        const UsernameWidget(),
                        const SizedBox(height: 16),
                        const DateAndGenderWidget(),
                        const SizedBox(height: 24),
                        const SubmitButton(),
                        // const ThreeDotLoading()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "TelX",
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
        Text(
          "Enter your details below and let's get started with TelX",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class FullNameWidget extends StatelessWidget {
  const FullNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: customInputDecoration(
          labelText: 'Full Name',
          hintText: "Enter your full name",
          context: context),
      onChanged: (fullName) {
        context.read<UserInfoFormCubit>().updateFullName(fullName);
      },
    );
  }
}

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoFormCubit, UserInfoFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: customInputDecoration(
                  labelText: "Username",
                  hintText: 'Chose a username',
                  context: context),
              onChanged: (userName) {
                context.read<UserInfoFormCubit>().updateUsername(userName);
              },
            ),
            SizedBox(
              height: 25,
              child: state.usernameMessage.isNotEmpty
                  ? Text(state.usernameMessage)
                  : const ThreeDotLoading(),
            )
          ],
        );
      },
    );
  }
}

class DateAndGenderWidget extends StatelessWidget {
  const DateAndGenderWidget({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<UserInfoFormCubit>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: AppColors.lightBlue,
                    onPrimary: AppColors.black,
                    onSurface: AppColors.white,
                  )
                : const ColorScheme.light(
                    primary: AppColors.lightBlue,
                    onPrimary: AppColors.white,
                    onSurface: AppColors.black,
                  ),
            dialogBackgroundColor: AppColors.black,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      cubit.selectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const _genders = ['Male', 'Female', 'Other'];

    return BlocBuilder<UserInfoFormCubit, UserInfoFormState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Picker
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: customInputDecoration(
                    labelText: 'Birthday',
                    hintText: 'Select your birthday',
                    context: context,
                  ),
                  child: Text(
                    state.selectedDate == null
                        ? 'Select your birthday'
                        : '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                    style: TextStyle(
                      color: state.selectedDate == null
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Gender Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: state.selectedGender,
                decoration: customInputDecoration(
                  labelText: 'Gender',
                  hintText: 'Select one',
                  context: context,
                ),
                items: _genders.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<UserInfoFormCubit>().selectGender(value);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
                dropdownColor:
                    isDarkMode ? AppColors.darkGray : AppColors.lightGray,
                iconEnabledColor: AppColors.darkGray,
                style: TextStyle(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            String? email = prefs.getString("userEmail");
            context.read<UserInfoFormCubit>().submitForm(context, email.toString());
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// class UserFormScreen extends StatefulWidget {
//   const UserFormScreen({super.key});
//
//   @override
//   _UserFormScreenState createState() => _UserFormScreenState();
// }
//
// class _UserFormScreenState extends State<UserFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _usernameController = TextEditingController();
//   DateTime? _selectedDate;
//   String? _selectedGender;
//   String? _selectDateHint;
//
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//
//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double boxHeight = deviceHeight / 3;
//     bool isMobile = DeviceUtils.isMobile();
//     bool isDarkMode = DeviceUtils.isDarkMode(context);
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         // appBar: AppBar(
//         //   title: const Text('User Registration'),
//         //   centerTitle: true,
//         // ),
//         body: BlocProvider(
//           create: (context) => UserInfoBloc(),
//           child: BlocConsumer<UserInfoBloc, UserInfoState>(
//             listener: (context, state) {
//               if (state is Confirmed) {
//                 String password = context
//                     .select((SignUpCubit cubit) => cubit.state.password.value);
//                 print("password is printing in user screen : $password");
//                 Navigator.pushNamed(context, RoutesNames.homeScreen);
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => const ChatScreen()));
//               }
//             },
//             builder: (context, state) {
//               return Align(
//                 alignment: isMobile ? Alignment.center : Alignment.topCenter,
//                 child: SingleChildScrollView(
//                     child: LayoutBuilder(builder: (context, constraints) {
//                   double formSize;
//                   if (constraints.maxWidth < 600) {
//                     formSize = double.infinity;
//                   } else {
//                     formSize = 500;
//                   }
//                   return SizedBox(
//                     width: formSize,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 16),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             if (!isMobile)
//                               SizedBox(
//                                 height: boxHeight * 0.1,
//                               ),
//
//                             // Todo: Logo
//                             const Text(
//                               "TelX",
//                               style: TextStyle(
//                                   fontSize: 70, fontWeight: FontWeight.bold),
//                             ),
//
//                             const Text(
//                               "Enter your details below and let's get started with TelX",
//                               style: TextStyle(fontSize: 18),
//                             ),
//
//                             const SizedBox(
//                               height: 20,
//                             ),
//
//                             // Full Name
//                             TextFormField(
//                               controller: _fullNameController,
//                               decoration: customInputDecoration(
//                                   labelText: 'Full Name',
//                                   hintText: "Enter your full name",
//                                   context: context),
//                               // decoration: InputDecoration(
//                               //   labelText: 'Full Name',
//                               //   hintText: 'Enter your full name',
//                               //   border: OutlineInputBorder(),
//                               //   prefixIcon: Icon(Icons.person),
//                               // ),
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return 'Full name is required';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Username
//                             TextFormField(
//                               controller: _usernameController,
//                               decoration: customInputDecoration(
//                                       labelText: "Username",
//                                       hintText: 'Chose a username',
//                                       context: context)
//                                   .copyWith(
//                                       helperText:
//                                           "Username should be unique and 8-15 characters long"),
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return 'Username is required';
//                                 }
//                                 return null;
//                               },
//                               onFieldSubmitted: (value) {},
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Birthday
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       _selectDate(isDarkMode);
//                                     },
//                                     child: InputDecorator(
//                                       decoration: customInputDecoration(
//                                           labelText: 'Birthday',
//                                           hintText: '$_selectDateHint',
//                                           context: context),
//                                       // decoration: const InputDecoration(
//                                       //   labelText: 'Birthday',
//                                       //   border: OutlineInputBorder(),
//                                       //   // prefixIcon: Icon(Icons.calendar_today),
//                                       // ),
//                                       child: Text(
//                                         _selectedDate == null
//                                             ? _selectDateHint =
//                                                 "Select your birthday"
//                                             : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
//                                         style: TextStyle(
//                                           color: _selectedDate == null
//                                               ? Colors.grey
//                                               : Theme.of(context)
//                                                   .textTheme
//                                                   .bodyLarge!
//                                                   .color,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: DropdownButtonFormField<String>(
//                                     value: _selectedGender,
//                                     decoration: customInputDecoration(
//                                       labelText: 'Gender',
//                                       hintText: 'Select one',
//                                       context: context,
//                                     ),
//                                     items: _genders.map((gender) {
//                                       return DropdownMenuItem<String>(
//                                         value: gender,
//                                         child: Text(
//                                           gender,
//                                           style: TextStyle(
//                                               color: isDarkMode
//                                                   ? AppColors.white
//                                                   : AppColors
//                                                       .black), // Customize text color
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedGender = value;
//                                       });
//                                     },
//                                     validator: (value) {
//                                       if (value == null) {
//                                         return 'Please select your gender';
//                                       }
//                                       return null;
//                                     },
//                                     dropdownColor: isDarkMode
//                                         ? AppColors.darkGray
//                                         : AppColors.lightGray,
//                                     // Set dropdown background color
//                                     iconEnabledColor: AppColors.darkGray,
//                                     // Set icon color
//                                     style: TextStyle(
//                                         color: isDarkMode
//                                             ? AppColors.white
//                                             : AppColors
//                                                 .black), // Set text color for selected item
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 24),
//
//                             // Submit Button
//                             Center(
//                               child: SizedBox(
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       // Process form data
//                                       context.read<UserInfoBloc>().add(
//                                           ConfirmAccount(
//                                               birthday: _selectedDate!,
//                                               gender: _selectedGender!,
//                                               fullName:
//                                                   _fullNameController.text,
//                                               userName:
//                                                   _usernameController.text));
//                                       // print('Full Name: ${_fullNameController.text}');
//                                       // print('Username: ${_usernameController.text}');
//                                       // print('Birthday: $_selectedDate');
//                                       // print('Gender: $_selectedGender');
//                                     }
//                                   },
//                                   child: const Text(
//                                     'Submit',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 })),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _selectDate(bool isDarkMode) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? const ColorScheme.dark(
//                     primary: AppColors.lightBlue, // Header background color
//                     onPrimary: AppColors.black, // Header text color
//                     onSurface: AppColors.white, // Body text color
//                   )
//                 : const ColorScheme.light(
//                     primary: AppColors.lightBlue, // Header background color
//                     onPrimary: AppColors.white, // Header text color
//                     onSurface: AppColors.black,
//                   ),
//             dialogBackgroundColor: AppColors.black,
//             // Background color of the dialog
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.primaryBlue, // Button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Process form data
//       context.read<UserInfoBloc>().add(ConfirmAccount(
//           birthday: _selectedDate!,
//           gender: _selectedGender!,
//           fullName: _fullNameController.text,
//           userName: _usernameController.text));
//       // print('Full Name: ${_fullNameController.text}');
//       // print('Username: ${_usernameController.text}');
//       // print('Birthday: $_selectedDate');
//       // print('Gender: $_selectedGender');
//     }
//   }
//
//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _usernameController.dispose();
//     super.dispose();
//   }
// }
