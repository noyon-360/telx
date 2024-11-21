// import 'package:flutter/services.dart';
//
// class DateFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final newValueString = newValue.text.replaceAll('/', '');
//     String formattedText = '';
//
//     for (int i = 0; i < newValueString.length; i++) {
//       formattedText += newValueString[i];
//
//       // Insert '/' after the 2nd and 4th digits for DD/MM/YYYY format
//       if ((i == 1 || i == 3) && i + 1 != newValueString.length) {
//         formattedText += '/';
//       }
//     }
//
//     return newValue.copyWith(
//       text: formattedText,
//       selection: TextSelection.fromPosition(
//         TextPosition(offset: formattedText.length),
//       ),
//     );
//   }
// }