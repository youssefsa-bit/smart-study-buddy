import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../routes/app_routes_name.dart';

class NetworkService {
  final SharedPreferences sharedPreferences;
  late Dio dio;

  NetworkService({required this.sharedPreferences}) {
    init();
  }

  void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:3000/api",
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = sharedPreferences.getString('ACCESS_TOKEN');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print("Token expired or invalid!");
            await sharedPreferences.remove('ACCESS_TOKEN');
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutesName.sessionExpired,
                  (route) => false,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }
}
