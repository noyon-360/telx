import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Sign%20Up%20Process/UserInfoBloc/user_info_bloc.dart';
import 'package:telx/data/theme/color.dart';
import 'package:telx/data/theme/light_dark_theme.dart';
import 'package:telx/presentation/screens/Home/chat_screen.dart';
import 'package:telx/presentation/widgets/custom_input_field_decorator.dart';
import 'package:telx/utils/device_utils.dart';

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectDateHint;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double boxHeight = deviceHeight / 3;
    bool isMobile = DeviceUtils.isMobile();
    bool isDarkMode = DeviceUtils.isDarkMode(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('User Registration'),
        //   centerTitle: true,
        // ),
        body: BlocProvider(
          create: (context) => UserInfoBloc(),
          child: BlocConsumer<UserInfoBloc, UserInfoState>(
            listener: (context, state) {
              if (state is Confirmed) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatScreen()));
              }
            },
            builder: (context, state) {
              return Align(
                alignment: isMobile ? Alignment.center : Alignment.topCenter,
                child: SingleChildScrollView(
                    child: LayoutBuilder(builder: (context, constraints) {
                  double formSize;
                  if (constraints.maxWidth < 600) {
                    formSize = double.infinity;
                  } else {
                    formSize = 500;
                  }
                  return SizedBox(
                    width: formSize,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!isMobile)
                              SizedBox(
                                height: boxHeight * 0.1,
                              ),

                            // Todo: Logo
                            const Text(
                              "TelX",
                              style: TextStyle(
                                  fontSize: 70, fontWeight: FontWeight.bold),
                            ),

                            const Text(
                              "Enter your details below and let's get started with TelX",
                              style: TextStyle(fontSize: 18),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // Full Name
                            TextFormField(
                              controller: _fullNameController,
                              decoration: customInputDecoration(
                                  labelText: 'Full Name',
                                  hintText: "Enter your full name",
                                  context: context),
                              // decoration: InputDecoration(
                              //   labelText: 'Full Name',
                              //   hintText: 'Enter your full name',
                              //   border: OutlineInputBorder(),
                              //   prefixIcon: Icon(Icons.person),
                              // ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Username
                            TextFormField(
                              controller: _usernameController,
                              decoration: customInputDecoration(
                                      labelText: "Username",
                                      hintText: 'Chose a username',
                                      context: context)
                                  .copyWith(
                                      helperText:
                                          "Username should be unique and 8-15 characters long"),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {},
                            ),
                            const SizedBox(height: 16),

                            // Birthday
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(isDarkMode);
                                    },
                                    child: InputDecorator(
                                      decoration: customInputDecoration(
                                          labelText: 'Birthday',
                                          hintText: '$_selectDateHint',
                                          context: context),
                                      // decoration: const InputDecoration(
                                      //   labelText: 'Birthday',
                                      //   border: OutlineInputBorder(),
                                      //   // prefixIcon: Icon(Icons.calendar_today),
                                      // ),
                                      child: Text(
                                        _selectedDate == null
                                            ? _selectDateHint =
                                                "Select your birthday"
                                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                        style: TextStyle(
                                          color: _selectedDate == null
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedGender,
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
                                              color: isDarkMode ? AppColors.white : AppColors
                                                  .black), // Customize text color
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select your gender';
                                      }
                                      return null;
                                    },
                                    dropdownColor: isDarkMode
                                        ? AppColors.darkGray
                                        : AppColors.lightGray,
                                    // Set dropdown background color
                                    iconEnabledColor: AppColors.darkGray,
                                    // Set icon color
                                    style: TextStyle(
                                        color: isDarkMode ? AppColors.white : AppColors
                                            .black), // Set text color for selected item
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Submit Button
                            Center(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Process form data
                                      context.read<UserInfoBloc>().add(
                                          ConfirmAccount(
                                              birthday: _selectedDate!,
                                              gender: _selectedGender!,
                                              fullName:
                                                  _fullNameController.text,
                                              userName:
                                                  _usernameController.text));
                                      // print('Full Name: ${_fullNameController.text}');
                                      // print('Username: ${_usernameController.text}');
                                      // print('Birthday: $_selectedDate');
                                      // print('Gender: $_selectedGender');
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectDate(bool isDarkMode) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: AppColors.lightBlue, // Header background color
                    onPrimary: AppColors.black, // Header text color
                    onSurface: AppColors.white, // Body text color
                  )
                : const ColorScheme.light(
                    primary: AppColors.lightBlue, // Header background color
                    onPrimary: AppColors.white, // Header text color
                    onSurface: AppColors.black,
                  ),
            dialogBackgroundColor: AppColors.black,
            // Background color of the dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form data
      context.read<UserInfoBloc>().add(ConfirmAccount(
          birthday: _selectedDate!,
          gender: _selectedGender!,
          fullName: _fullNameController.text,
          userName: _usernameController.text));
      // print('Full Name: ${_fullNameController.text}');
      // print('Username: ${_usernameController.text}');
      // print('Birthday: $_selectedDate');
      // print('Gender: $_selectedGender');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
