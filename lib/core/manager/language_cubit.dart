import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  final SharedPreferences prefs;
  LanguageCubit({required this.prefs}) : super(const Locale('en')) {
    _loadLanguage();
  }
  void _loadLanguage() {
    if (prefs.containsKey('LANGUAGE_CODE')) {
      final langCode = prefs.getString('LANGUAGE_CODE') ?? 'en';
      emit(Locale(langCode));
    } else {
      final deviceLang = PlatformDispatcher.instance.locale.languageCode;
      final langToSet = (deviceLang == 'ar') ? 'ar' : 'en';
      prefs.setString('LANGUAGE_CODE', langToSet);
      emit(Locale(langToSet));
    }
  }

  Future<void> changeLanguage(String langCode) async {
    await prefs.setString('LANGUAGE_CODE', langCode);
    emit(Locale(langCode));
  }
}
