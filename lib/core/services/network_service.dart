import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          // String? token =
          //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3MjIyODY3NSwiZXhwIjoxNzcyMjM5NDc1fQ.Pzasv2A3uQIhNZHLA-w59-bTnF3EpiiRj8_gN0ts0bo";
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            print("Token expired or invalid!");
          }
          return handler.next(e);
        },
      ),
    );
  }
}
