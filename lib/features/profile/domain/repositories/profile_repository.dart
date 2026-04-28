import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> updateName(String name);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> logout();
}