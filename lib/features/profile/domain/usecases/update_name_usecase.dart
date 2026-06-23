import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateNameUseCase {
  final ProfileRepository repository;
  UpdateNameUseCase(this.repository);

  Future<UserProfileEntity> call(String name) async => await repository.updateName(name);
}
