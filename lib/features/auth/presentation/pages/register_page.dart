import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // لا تنسى الـ import ده
import '../../../../core/constants/app_colors.dart';
import '../manager/auth_bloc.dart';
import '../manager/auth_event.dart';
import '../manager/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 1. تعريف الـ Controllers لسحب البيانات
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

              // 2. ربط الـ Controllers بالحقول
              CustomTextField(
                  controller: _nameController,
                  labelText: "Full Name",
                  prefixIcon: Icons.person_outline
              ),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _emailController,
                  labelText: "Email Address",
                  prefixIcon: Icons.email_outlined
              ),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _passwordController,
                  labelText: "Password",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true
              ),

              const SizedBox(height: 32),

              // 3. استخدام BlocConsumer للربط مع الـ Logic
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                    );
                    // بعد النجاح نرجعه لصفحة الـ Login أو ندخله للهوم
                    Navigator.pushReplacementNamed(context, '/login');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error), backgroundColor: Colors.redAccent),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                  }

                  return AuthButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _nameController.text.isNotEmpty) {

                        // إرسال حدث التسجيل للـ Bloc
                        context.read<AuthBloc>().add(
                          RegisterRequested(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all fields")),
                        );
                      }
                    },
                  );
                },
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}