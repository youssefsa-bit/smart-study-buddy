// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              const CustomTextField(labelText:  "Email", prefixIcon: Icons.email_outlined),
              const SizedBox(height: 16),
              const CustomTextField(labelText: "Password", prefixIcon: Icons.lock_outline, isPassword: true),

              const SizedBox(height: 32),
              AuthButton(
                text: "Login",
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),

              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("New here? Create Account", style: TextStyle(color: AppColors.primaryBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}