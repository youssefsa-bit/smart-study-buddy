import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/services/injection_container.dart' as di;
import 'features/main_layout/presentation/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StudyFlow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryBlue,
            surface: AppColors.surface,
          ),
          fontFamily: 'Inter',
        ),
        home: MainScreen());
  }
}
