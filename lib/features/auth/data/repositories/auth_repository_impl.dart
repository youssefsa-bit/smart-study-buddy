import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<User> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    await localDataSource.cacheTokens(user.accessToken, user.refreshToken);
    await localDataSource.cacheUserName(user.name ?? "");
    return user;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final user = await remoteDataSource.register(name, email, password);
    await localDataSource.cacheTokens(user.accessToken, user.refreshToken);
    await localDataSource.cacheUserName(name);
    return user;
  }

  @override
  Future<String?> getCachedUserName() async {
    return await localDataSource.getCachedUserName();
  }
}
