// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Fill your details ", style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 40),

              const CustomTextField(labelText: "Full Name", prefixIcon: Icons.person_outline),
              const SizedBox(height: 16),
              const CustomTextField(labelText: "Email Address", prefixIcon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(labelText:  "Password", prefixIcon: Icons.lock_outline, isPassword: true),

              const SizedBox(height: 32),
              AuthButton(
                text: "Sign Up",
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),

              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: AppColors.textGrey),
                      children: [
                        TextSpan(text: "Login", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}