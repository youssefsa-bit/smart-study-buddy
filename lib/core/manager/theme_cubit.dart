import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;

  ThemeCubit({required this.prefs}) : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() {
    final isLight = prefs.getBool('IS_LIGHT_MODE') ?? false;
    AppColors.isLightMode = isLight;
    emit(isLight ? ThemeMode.light : ThemeMode.dark);
  }
  Future<void> changeTheme(ThemeMode mode) async {
    final isLight = mode == ThemeMode.light;
    AppColors.isLightMode = isLight;
    await prefs.setBool('IS_LIGHT_MODE', isLight);

    emit(mode);
  }
  // Future<void> toggleTheme() async {
  //   final isLight = state == ThemeMode.light;
  //   final newIsLight = !isLight;
  //
  //   AppColors.isLightMode = newIsLight;
  //   await prefs.setBool('IS_LIGHT_MODE', newIsLight);
  //
  //   emit(newIsLight ? ThemeMode.light : ThemeMode.dark);
  // }
}
