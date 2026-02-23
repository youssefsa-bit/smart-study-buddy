import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';


void main() {
  runApp(const StudyBuddyApp());
}

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter', // تأكد من تعريفه في pubspec.yaml
      ),

      // الشاشة التي ستبدأ عند فتح التطبيق
      initialRoute: '/login',

      // هنا يتم تعريف الـ Routes
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),

      },
    );
  }
}