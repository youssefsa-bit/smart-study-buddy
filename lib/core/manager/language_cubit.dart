import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  final SharedPreferences prefs;
  LanguageCubit({required this.prefs}) : super(const Locale('en')) {
    _loadLanguage();
  }
  void _loadLanguage() {
    final langCode = prefs.getString('LANGUAGE_CODE') ?? 'en';
    emit(Locale(langCode));
  }

  Future<void> changeLanguage(String langCode) async {
    await prefs.setString('LANGUAGE_CODE', langCode);
    emit(Locale(langCode));
  }
}