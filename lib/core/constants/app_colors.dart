import 'package:study_buddy/core/constants/app_colors.dart';
import 'dart:ui';

class AppColors {
  static bool isLightMode = false;

  static Color get cardBg => isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFF121212);
  static Color get textGrey => const Color(0xFF9E9E9E);
  static Color get accentOrange => const Color(0xFFFF8C42);
  
  static Color get background =>
      isLightMode ? const Color(0xFFF9FAFB) : const Color(0xFF0D0D0D);
  static Color get surface =>
      isLightMode ? const Color(0xFFFFFFFF) : const Color(0xFF1A1C20);
  static Color get surfaceHighlight =>
      isLightMode ? const Color(0xFFF3F4F6) : const Color(0xFF25282D);
      
  static Color get darkBlue => isLightMode ? const Color(0xFFE3F2FD) : const Color(0xff023657);
  static Color get darkGreen => isLightMode ? const Color(0xFFE8F5E9) : const Color(0xff061e28);
  
  // --- Primary & Accents ---
  static Color get primaryBlue => const Color(0xFF246BFD);
  static Color get primaryGreen => const Color(0xFF1E9B9E);
  static Color get mcqOrange => const Color(0xFFFF7A00);
  static Color get mcqImg => isLightMode ? const Color(0xFFFFF3E0) : const Color(0xff311f1d);
  static Color get flashcardGreen => const Color(0xFF00C566);
  static Color get flashcardImg => isLightMode ? const Color(0xFFE8F5E9) : const Color(0xff0e2c27);
  static Color get summarizePurple => const Color(0xFF8A2BE2);
  
  // --- Text Colors ---
  static Color get textPrimary =>
      isLightMode ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
  static Color get textSecondary =>
      isLightMode ? const Color(0xFF6B7280) : const Color(0xFFA0A0A0);
      
  // --- Borders & Dividers ---
  static Color get border =>
      isLightMode ? const Color(0xFFE5E7EB) : const Color(0xFF2A2A2A);
  static Color get leading =>
      isLightMode ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
}
