import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/summary/presentation/pages/summary_screen.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/session_expired_screen.dart';
import '../../features/flashcards/presentation/pages/flashcard_screen.dart';
import '../../features/main_layout/presentation/pages/main_screen.dart';
import '../../features/mcq/presentation/pages/mcq_screen.dart';
import '../../features/profile/presentation/manager/profile_bloc.dart';
import '../../features/profile/presentation/pages/change_password_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import 'app_routes_name.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutesName.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutesName.main:
        final int initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainScreen(initialIndex: initialIndex),
        );
      case AppRoutesName.flashcards:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => FlashcardScreen(
              pdfId: args['pdfId'],
              resultId: args['resultId'],
              fileName: args['fileName']),
        );
      case AppRoutesName.summarize:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => SummaryScreen(
                pdfId: args['pdfId'],
                resultId: args['resultId'],
                fileName: args['fileName']));
      case AppRoutesName.mcq:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => McqScreen(
              pdfId: args['pdfId'],
              resultId: args['resultId'],
              fileName: args['fileName']),
        );
      case AppRoutesName.editProfile:
        final profileBloc = settings.arguments as ProfileBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: profileBloc,
            child: const EditProfileScreen(),
          ),
        );
      case AppRoutesName.changePassword:
        final profileBloc = settings.arguments as ProfileBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: profileBloc,
            child: const ChangePasswordScreen(),
          ),
        );

      case AppRoutesName.sessionExpired:
        return MaterialPageRoute(builder: (_) => const SessionExpiredScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Route Not Found')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
