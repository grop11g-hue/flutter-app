import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF101318);
  static const Color card = Color(0xFF202630);
  static const Color cardLight = Color(0xFF2A313D);
  static const Color border = Color(0xFF2F3744);
  static const Color orange = Color(0xFFFF6B24);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA7ADB7);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE5484D);
  static const Color warning = Color(0xFFF5A524);

  // Pre-computed translucent colors (avoids deprecated withOpacity).
  static const Color orangeSoft = Color(0x26FF6B24);
  static const Color shadow = Color(0x40000000);
  static const Color scrim = Color(0x99101318);

  /// Maps a product color name to an actual color.
  static Color fromName(String name) {
    switch (name.toLowerCase()) {
      case 'black':
        return const Color(0xFF111111);
      case 'orange':
        return orange;
      case 'white':
        return const Color(0xFFF2F3F5);
      case 'blue':
        return const Color(0xFF2F6BFF);
      case 'red':
        return const Color(0xFFE5484D);
      case 'green':
        return const Color(0xFF2ECC71);
      case 'purple':
        return const Color(0xFF9B30D9);
      case 'yellow':
        return const Color(0xFFFFD60A);
      case 'grey':
        return const Color(0xFF8A8F98);
      default:
        return textSecondary;
    }
  }
}
