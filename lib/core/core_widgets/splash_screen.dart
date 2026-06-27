import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_assets.dart';
import '../../core/services/injection_container.dart' as di;
import '../routes/app_routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInit = true;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(_isInit){
      precacheImage( AssetImage(AppAssets.splash), context).then((_) {
        FlutterNativeSplash.remove();
        _handleNavigation();
      });
      _isInit = false;
    }
  }
  void _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    String nextRoute = AppRoutesName.login;
    try {
      final prefs = di.sl<SharedPreferences>();
      bool isFirstTime = prefs.getBool('IS_FIRST_TIME') ?? true;

      if (isFirstTime) {
        nextRoute = AppRoutesName.onboarding;
      } else {
        final String? token = prefs.getString('ACCESS_TOKEN');
        if (token != null && token.isNotEmpty) {
          try {
            if (JwtDecoder.isExpired(token)) {
              await prefs.remove('ACCESS_TOKEN');
              nextRoute = AppRoutesName.sessionExpired;
            } else {
              nextRoute = AppRoutesName.main;
            }
          } catch (e) {
            print("JWT Decoder Error: $e");
            await prefs.remove('ACCESS_TOKEN');
            nextRoute = AppRoutesName.login;
          }
        }
      }
    } catch (e) {
      print("Fatal Splash Error: $e");
      nextRoute = AppRoutesName.login;
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(AppAssets.splash,fit: BoxFit.fill,),
      ),
    );
  }
}