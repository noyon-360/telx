import 'package:flutter/material.dart';
import 'package:telx/data/theme/color.dart';

enum SnackBarType { normal, success, failure, loading, info }

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
}) {
  Color backgroundColor;
  IconData icon;

  // Set colors and icons based on SnackBarType
  switch (type) {
    case SnackBarType.normal:
      backgroundColor = Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkGray
          : AppColors.gray;
      icon = Icons.info_outline;
      break;
    case SnackBarType.success:
      backgroundColor = AppColors.success;
      icon = Icons.check_circle;
      break;
    case SnackBarType.failure:
      backgroundColor = AppColors.error;
      icon = Icons.error;
      break;
    case SnackBarType.loading:
      backgroundColor = Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBlue
          : AppColors.lightBlue;
      icon = Icons.info;
      break;
    case SnackBarType.info:
      backgroundColor = AppColors.warning;
      icon = Icons.info_outline;
      break;
  }

  // Show SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: AppColors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}