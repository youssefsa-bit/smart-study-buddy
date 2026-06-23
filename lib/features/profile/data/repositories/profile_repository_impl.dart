import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfileEntity> getProfile() async => await remoteDataSource.getProfile();

  @override
  Future<UserProfileEntity> updateName(String name) async => await remoteDataSource.updateName(name);

  @override
  Future<void> changePassword(String current, String newPass) async => await remoteDataSource.changePassword(current, newPass);

  @override
  Future<void> logout() async => await remoteDataSource.logout();
}
