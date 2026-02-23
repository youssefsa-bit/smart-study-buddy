// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:dio/dio.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio = Dio(BaseOptions(baseUrl: 'YOUR_API_BASE_URL')); // ضع رابط السيرفر هنا

  Future<AuthResponse> register(String name, String email, String password) async {
    try {
      final response = await dio.post('/api/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Registration Failed";
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Login Failed";
    }
  }
}