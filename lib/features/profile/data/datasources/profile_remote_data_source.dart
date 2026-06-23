import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/network_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();

  Future<UserProfileModel> updateName(String name);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final NetworkService networkService;

  ProfileRemoteDataSourceImpl({required this.networkService});

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await networkService.dio.get('/profile'); //
    return UserProfileModel.fromJson(response.data['data']['user']);
  }

  @override
  Future<UserProfileModel> updateName(String name) async {
    final response = await networkService.dio.patch(
      '/profile', // [cite: 358-368]
      data: {"name": name},
    );
    return UserProfileModel.fromJson(response.data['data']['user']);
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await networkService.dio.patch(
      '/profile/password', // [cite: 369-381]
      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
    );
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await networkService.dio.post('/auth/logout');
    } catch (e) {}
    finally {
      await prefs.remove('ACCESS_TOKEN');
    }
  }
}
