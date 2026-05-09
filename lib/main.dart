import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:study_buddy/features/auth/presentation/manager/auth_event.dart';
import 'core/constants/app_colors.dart';
import 'core/manager/language_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_name.dart';
import 'core/services/injection_container.dart' as di;
import 'features/auth/presentation/manager/auth_bloc.dart';
import 'features/history/presentation/manager/history_bloc.dart';
import 'features/history/presentation/manager/history_event.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final prefs = di.sl<SharedPreferences>();
  final String? token = prefs.getString('ACCESS_TOKEN');
  String startRoute = AppRoutesName.login;
  if (token != null && token.isNotEmpty) {
    try {
      if (JwtDecoder.isExpired(token)) {
        await prefs.remove('ACCESS_TOKEN');
        startRoute = AppRoutesName.sessionExpired;
      } else {
        startRoute = AppRoutesName.main;
      }
    } catch (e) {
      await prefs.remove('ACCESS_TOKEN');
      startRoute = AppRoutesName.login;
    }
  }

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
        BlocProvider<HistoryBloc>(
          create: (context) => di.sl<HistoryBloc>()..add(LoadHistory()),
        ),
        BlocProvider(
          create: (context) => di.sl<LanguageCubit>(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return  MaterialApp(
            navigatorKey: navigatorKey,
            title: 'StudyFlow',
            debugShowCheckedModeBanner: false,
            locale:locale,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
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
        },

      ),
    );
  }
}

