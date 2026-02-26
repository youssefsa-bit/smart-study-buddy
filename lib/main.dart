import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // مهم جداً للـ BlocProvider
import 'core/constants/app_colors.dart';
import 'core/services/injection_container.dart' as di; // عملنا import للـ DI
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/manager/auth_bloc.dart';

void main() async {
  // يضمن أن الفلاتر جاهز قبل تشغيل أي كود async
  WidgetsFlutterBinding.ensureInitialized();

  // تشغيل الـ Dependency Injection (مهم جداً قبل runApp)
  await di.init();

  runApp(const StudyBuddyApp());
}

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم MultiBlocProvider في أعلى الشجرة عشان الـ Bloc يكون متاح لكل الشاشات
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(), // بيجيب نسخة الـ Bloc من الـ GetIt
        ),
      ],
      child: MaterialApp(
        title: 'Smart Study Buddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Inter',
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const RegisterPage(),
          // ضيف هنا مسار الـ Home لما تخلصها
          // '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}