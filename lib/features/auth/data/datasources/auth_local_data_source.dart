import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens(String accessToken, String refreshToken);
  Future<void> clearTokens();
}
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheTokens(String accessToken, String refreshToken) async {
    await sharedPreferences.setString('ACCESS_TOKEN', accessToken);
    await sharedPreferences.setString('REFRESH_TOKEN', refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await sharedPreferences.remove('ACCESS_TOKEN');
    await sharedPreferences.remove('REFRESH_TOKEN');
  }
}