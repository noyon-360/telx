import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  final String subtitle;
  const LogoSection({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "TelX",
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
