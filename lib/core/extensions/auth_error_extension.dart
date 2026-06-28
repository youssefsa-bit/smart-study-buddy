import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AuthErrorExtension on String {
  String localized(AppLocalizations loc) {
    final error = toLowerCase();

    if (error.contains("invalid credentials") ||
        error.contains("invalid email") ||
        error.contains("wrong password")) {
      return loc.invalidCredentials;
    }

    if (error.contains("already exists") ||
        error.contains("already registered")) {
      return loc.emailAlreadyExists;
    }

    if (error.contains("connection") ||
        error.contains("network") ||
        error.contains("socket")) {
      return loc.networkError;
    }

    return loc.somethingWentWrong;
  }
}