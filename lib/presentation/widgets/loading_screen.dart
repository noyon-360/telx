import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent background
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
