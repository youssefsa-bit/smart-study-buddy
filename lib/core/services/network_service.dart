import 'package:dio/dio.dart';

class NetworkService {
  NetworkService._() {
    init();
  }
  //singleton
  static NetworkService? _instance;
  factory NetworkService() {
    _instance ??= NetworkService._();
    return _instance!;
  }
  late Dio dio;
  void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:3000/api",
        followRedirects: false,
        validateStatus: (status) {
          if (status != null) {
            if (status <= 300) {
              return true;
            } else if (status == 401) {
              return false;
            } else {
              return false;
            }
          } else {
            return false;
          }
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token =
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3MjE0NzkyNiwiZXhwIjoxNzcyMTU4NzI2fQ.6BVvjr6ckiz72XOisYFtTIRsttKBhFjt7r1Td_X8oP4";

          options.headers['Authorization'] = 'Bearer $token';

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
