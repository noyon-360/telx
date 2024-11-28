// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:telx/config/routes/routes_names.dart';
// import 'package:telx/repositories/authentication_repository.dart';
//
// import '../../../src/models/user.dart';
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _checkUserStatus(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return const Scaffold(
//             body: Center(
//               child: Text('An error occurred. Please try again.'),
//             ),
//           );
//         }
//         // If future completes successfully, the screen will already navigate
//         return const Scaffold(
//           body: Center(
//             child: Text('Redirecting...'),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _checkUserStatus(BuildContext context) async {
//     // Simulate a loading delay
//     await Future.delayed(const Duration(seconds: 2));
//
//     // Replace with your actual authentication logic
//     final authRepository = AuthenticationRepository();
//     final user = authRepository.currentUser;
//
//     print("Im printing the user in splash screen : $user");
//     if (user != User.empty) {
//       // check the user exist on firebase database
//       // Check if the user exists in Firebase Firestore
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.email).get();
//       if(!userDoc.exists){
//       Navigator.pushNamedAndRemoveUntil(context, RoutesNames.authScreen, (route) => false,);
//
//       }
//       // Navigate to Home Screen
//       Navigator.pushNamedAndRemoveUntil(context, RoutesNames.homeScreen, (route) => false,);
//     } else {
//       // Navigate to Login Screen
//       Navigator.pushNamedAndRemoveUntil(context, RoutesNames.authScreen, (route) => false,);
//       // Navigator.pushNamed(context, RoutesNames.authScreen);
//     }
//   }
// }
