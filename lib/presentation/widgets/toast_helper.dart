// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// enum ToastType { normal, success, failure, loading, info }
//
// void showCustomToast(String message, ToastType type) {
//   Color backgroundColor;
//   IconData icon;
//
//   switch (type) {
//     case ToastType.normal:
//       backgroundColor = Colors.blueGrey;
//       icon = Icons.info_outline;
//       break;
//     case ToastType.success:
//       backgroundColor = Colors.green;
//       icon = Icons.check_circle;
//       break;
//     case ToastType.failure:
//       backgroundColor = Colors.red;
//       icon = Icons.error;
//       break;
//     case ToastType.loading:
//       backgroundColor = Colors.blue;
//       icon = Icons.info;
//       break;
//     case ToastType.info:
//       backgroundColor = Colors.orange;
//       icon = Icons.info_outline;
//       break;
//   }
//
//   Fluttertoast.showToast(
//     msg: " $message",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 1,
//     backgroundColor: backgroundColor,
//     textColor: Colors.white,
//     fontSize: 16.0,
//     webPosition: "center",
//     webBgColor: backgroundColor.toString(),
//   );
// }
