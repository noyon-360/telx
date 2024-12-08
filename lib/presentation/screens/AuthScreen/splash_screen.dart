import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/routes_names.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../src/models/user.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationRepository authRepository;

  const SplashScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    // Listen to the user stream and navigate accordingly
    authRepository.user.listen((user) async {
      try {
        // Ensure that the user is authenticated and has a valid email
        if (user == UserModel.empty || user.id!.isEmpty) {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesNames.authSwitchScreen, (route) => false);
          return;
        }

        // Fetch user document using email
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)  // Assuming the document ID is the user's email
            .get();

        // If the user is authenticated and document exists
        if (userDoc.exists) {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesNames.homeScreen, (route) => false);
        } else {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesNames.loginScreen, (route) => false);
        }
      } catch (e) {
        print("Error while checking user document: $e");
        // Handle any other errors (e.g., network issues, permission issues)
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesNames.loginScreen, (route) => false);
      }
    });

    // Show a centered loading indicator
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
