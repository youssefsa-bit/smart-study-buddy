import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_name.dart';
import 'core/services/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final prefs = di.sl<SharedPreferences>();
  final String? token = prefs.getString('ACCESS_TOKEN');
  final String startRoute = (token != null && token.isNotEmpty)
      ? AppRoutesName.main
      : AppRoutesName.login;
  runApp(StudyFlowApp(
    initialRoute: startRoute,
  ));
}

class StudyFlowApp extends StatelessWidget {
  final String initialRoute;

  const StudyFlowApp({super.key, required this.initialRoute});

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
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
