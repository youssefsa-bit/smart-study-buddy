import 'package:dio/dio.dart';

class NetworkService {
  // Singleton pattern to ensure only one instance of the class exists
  NetworkService._() {
    init();
  }

  static NetworkService? _instance;
  factory NetworkService() {
    _instance ??= NetworkService._();
    return _instance!;
  }

  late Dio dio;

  void init() {
    dio = Dio(
      BaseOptions(
        // 10.0.2.2 is the special IP for Android Emulator to access localhost
        baseUrl: "http://10.0.2.2:3000/api",

        // Connection timeout (10 seconds)
        connectTimeout: const Duration(seconds: 10),

        // Receive timeout (10 seconds)
        receiveTimeout: const Duration(seconds: 10),

        // Default headers
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        // Allow receiving responses even with error codes (400, 401, etc.)
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500; // Accept any status code below 500
        },
      ),
    );

    // Logging Interceptor to monitor requests and responses in the console
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print("DIO_LOG: $object"),
    ));
  }
}