import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:study_buddy/features/auth/presentation/manager/auth_event.dart';

import 'core/constants/app_colors.dart';
import 'core/manager/language_cubit.dart';
import 'core/manager/theme_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_routes_name.dart';
import 'core/services/injection_container.dart' as di;
import 'features/auth/presentation/manager/auth_bloc.dart';
import 'features/history/presentation/manager/history_bloc.dart';
import 'features/history/presentation/manager/history_event.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await di.init();
  runApp(const StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

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
        BlocProvider(
          create: (context) => di.sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'StudyFlow',
                debugShowCheckedModeBanner: false,
                locale: locale,
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
                themeMode: themeMode,
                theme: ThemeData(
                  scaffoldBackgroundColor: AppColors.background,
                  colorScheme: ColorScheme.light(
                    primary: AppColors.primaryBlue,
                    surface: AppColors.surface,
                  ),
                  fontFamily: 'Inter',
                ),
                darkTheme: ThemeData(
                  scaffoldBackgroundColor: AppColors.background,
                  colorScheme: ColorScheme.dark(
                    primary: AppColors.primaryBlue,
                    surface: AppColors.surface,
                  ),
                  fontFamily: 'Inter',
                ),
                initialRoute: AppRoutesName.splash,
                onGenerateRoute: AppRoutes.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
