import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  // Check if the platform is mobile
  static bool isMobile() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  // Check if the app is in dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}