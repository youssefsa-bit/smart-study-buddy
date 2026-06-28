import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/auth/domain/entities/auth_message.dart';

extension AuthMessageExtension on AuthMessage {
  String localized(AppLocalizations loc) {
    switch (this) {
      case AuthMessage.loginSuccess:
        return loc.loginSuccess;

      case AuthMessage.registerSuccess:
        return loc.registerSuccess;

      case AuthMessage.welcomeBack:
        return loc.welcomeBackMessage;
    }
  }
}