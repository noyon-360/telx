import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telx/bloc/Theme%20Management/them_cubit.dart';
import 'package:telx/bloc/auth/google/google_button_bloc.dart';

class GoogleButtonWidget extends StatelessWidget {
  final double formSize;

  const GoogleButtonWidget({super.key, required this.formSize});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoogleButtonBloc(),
      child: BlocConsumer<GoogleButtonBloc, GoogleButtonState>(
          builder: (context, state) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
            // context.read<GoogleButtonBloc>().add(GoogleButtonPressed());
          },
          child: Container(
            width: formSize,
            height: 50,
            decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                width: 1.0
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 30,
                    child: Image.asset(
                      'assets/google.png',
                    )),
                const SizedBox(
                  width: 10,
                ),
                const Text("Continue With Google", style: TextStyle(fontSize: 16),)
              ],
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is GoogleButtonSuccess) {
        } else if (state is GoogleButtonFailure) {
        } else if (state is GoogleButtonLoading) {}
      }),
    );
  }
}
