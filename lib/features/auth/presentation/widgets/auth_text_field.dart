// lib/features/auth/presentation/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';


class CustomTextField extends StatelessWidget {
  final String labelText; // غيرنا hintText إلى labelText
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        // استخدام label بدلاً من hint
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),

        // هذا السطر يضمن أن الـ label يصعد للأعلى دائماً عند التفاعل
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),

        prefixIcon: Icon(prefixIcon, color: AppColors.primaryBlue, size: 20),
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),

        // الحواف في الحالة العادية
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),

        // الحواف عند الضغط (Focus)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),

        // الحواف عند وجود خطأ
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}