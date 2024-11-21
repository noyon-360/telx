// import 'package:flutter/material.dart';
//
// class CircularProgressWidget extends StatelessWidget {
//   final int currentStep;
//
//   const CircularProgressWidget({super.key, required this.currentStep});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         CustomPaint(
//           size: const Size(50, 50),
//           painter: CircularStepPainter(currentStep),
//         ),
//         // Center text displaying the current step
//         Align(
//           alignment: Alignment.center,
//           child: Text(
//             '$currentStep',
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CircularStepPainter extends CustomPainter {
//   final int currentStep;
//   static const double gapAngle = 0.1; // Small gap angle in radians
//
//   CircularStepPainter(this.currentStep);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 10;
//
//     // Draw the complete background circle
//     paint.color = Colors.grey.withOpacity(0.3);
//     canvas.drawCircle(Offset(radius, radius), radius, paint);
//
//     // Draw progress segments with gaps
//     paint.color = Colors.blue;
//     double startAngle = -3.141592653589793 / 2; // Starting at the top of the circle
//     double segmentAngle = (2 * 3.141592653589793 / 3) - gapAngle; // Each segment angle minus gap
//
//     for (int i = 0; i < 3; i++) {
//       if (i < currentStep) {
//         // Draw each segment with a gap
//         canvas.drawArc(
//           Rect.fromCircle(center: Offset(radius, radius), radius: radius),
//           startAngle,
//           segmentAngle,
//           false,
//           paint,
//         );
//       }
//       // Move start angle to the next segment, including the gap
//       startAngle += segmentAngle + gapAngle;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
