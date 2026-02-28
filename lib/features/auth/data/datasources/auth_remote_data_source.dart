import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.data != null && response.data['success'] == true) {
        return UserModel.fromJson(response.data);
      } else {
        throw response.data['message'] ??
            "Login failed. Please check your credentials.";
      }
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          "Connection error. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.data != null && response.data['success'] == true) {
        return UserModel.fromJson(response.data);
      } else {
        throw response.data['message'] ?? "Registration failed. Try again.";
      }
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          "Connection error. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }
}
