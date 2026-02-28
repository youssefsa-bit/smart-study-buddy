import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/features/auth/presentation/manager/auth_event.dart';

import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_name.dart';
import 'core/services/injection_container.dart' as di;
import 'features/auth/presentation/manager/auth_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus())),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
