import 'package:flutter/material.dart';
import 'package:telx/bloc/Sign%20Up%20Process/SignupCubit/signup_cubit.dart';
import 'package:telx/data/theme/color.dart';

String mapStrengthToText (PasswordStrength strength) {
  switch (strength) {
    case PasswordStrength.weak:
      return "Weak";
    case PasswordStrength.average:
      return "Average";
    case PasswordStrength.strong:
      return "Strong";
    case PasswordStrength.secure:
      return "Secure";
  }
}

Color mapStrengthToColor(PasswordStrength strength) {
  switch (strength) {
    case PasswordStrength.weak:
      return AppColors.error;
    case PasswordStrength.average:
      return AppColors.warning;
    case PasswordStrength.strong:
      return AppColors.primaryBlue;
    case PasswordStrength.secure:
      return AppColors.success;
  }
}

IconData mapStrengthToIcon(PasswordStrength strength) {
  switch (strength) {
    case PasswordStrength.weak:
      return Icons.lock_open;
    case PasswordStrength.average:
      return Icons.lock;
    case PasswordStrength.strong:
      return Icons.security;
    case PasswordStrength.secure:
      return Icons.verified_user;
    default:
      return Icons.help_outline;
  }
}

PasswordStrength calculatePasswordStrength(String password){
  if (password.isEmpty) return PasswordStrength.weak;

  int score = 0;

  if (password.length >= 8) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'\d').hasMatch(password)) score++;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  switch (score) {
    case 1:
      return PasswordStrength.weak;
    case 2:
      return PasswordStrength.average;
    case 3:
      return PasswordStrength.strong;
    case 4:
      return PasswordStrength.secure;
    default:
      return PasswordStrength.weak;
  }
}

Widget buildStrengthIndicator(PasswordStrength strength) {
  return Row(
    children: [
      _buildStrengthSegment(strength, 1),
      _buildStrengthSegment(strength, 2),
      _buildStrengthSegment(strength, 3),
      _buildStrengthSegment(strength, 4)
    ],
  );
}

Widget _buildStrengthSegment(PasswordStrength strength, int segment) {
  Color color = Colors.grey[300]!; // Default color for inactive segments
  if (strength.index + 1 >= segment) {
    color = mapStrengthToColor(strength); // Active color
  }

  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );
}

void showPasswordStrengthRules(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Password Strength Rules"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "• **Weak**: Less than 8 characters",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "• **Average**: At least 8 characters and includes numbers",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "• **Strong**: At least 8 characters, numbers, and one uppercase letter",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "• **Secure**: At least 8 characters, numbers, uppercase letters, and special symbols",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

