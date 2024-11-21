import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
}) {
  final MaterialColor backgroundColor;
  final IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackBarType.failure:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case SnackBarType.loading:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.orange;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ))
        ],
      )));
}

enum SnackBarType { success, failure, loading, info }
