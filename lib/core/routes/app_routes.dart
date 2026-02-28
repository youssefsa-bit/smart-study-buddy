import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/flashcards/presentation/pages/flashcard_screen.dart';
import '../../features/main_layout/presentation/pages/main_screen.dart';
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
        final pdfId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => FlashcardScreen(pdfId: pdfId),
        );
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
