import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telx/data/api/apis.dart';

class EmailVerifyCodeRepository {
  final String apiUrl;

  EmailVerifyCodeRepository(this.apiUrl);

  static Future<void> sendVerificationCode(String userEmail) async {
    try {
      final response = await http.post(Uri.parse(Apis.emailSendApi),
          headers: {'Content-Type' : 'application/json'},
              body: jsonEncode({'email': userEmail}));

      if (response.statusCode == 200) {
        print("Verification code send successfully");
      } else if (response.statusCode == 400) {
        // Handle missing email
        throw Exception('Email is required.');
      } else if (response.statusCode == 404) {
        // Handle email not found
        throw Exception('Email not found. Please check and try again.');
      } else if (response.statusCode == 500) {
        // Handle server errors
        throw Exception('Failed to send email. Please try again later.');
      } else {
        // Handle unexpected status codes
        throw Exception('Something went wrong. Please try again.');
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}
