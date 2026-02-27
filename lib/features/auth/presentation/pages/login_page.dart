import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // السطر ده اللي هيشيل الخطأ بتاع BlocConsumer
import '../../../../core/constants/app_colors.dart';
import '../manager/auth_bloc.dart';
import '../manager/auth_event.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. تعريف الـ Controllers لسحب البيانات
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              const Text("Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              // 2. ربط الـ Controllers بالحقول
              CustomTextField(
                  controller: _emailController,
                  labelText: "Email",
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

              // 3. استخدام BlocConsumer للربط مع الـ Logic والسيرفر
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    // لو الدخول نجح، روح للهوم
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state is AuthFailure) {
                    // لو فشل، طلع رسالة الخطأ اللي جاية من الباك-إيند
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
                    text: "Login",
                    onPressed: () {
                      if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                        // إرسال طلب الدخول للـ Bloc
                        context.read<AuthBloc>().add(
                          LoginRequested(
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
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("New here? Create Account",
                      style: TextStyle(color: AppColors.primaryBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}