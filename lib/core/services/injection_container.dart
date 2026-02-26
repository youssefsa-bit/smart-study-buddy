import 'package:get_it/get_it.dart';

// Auth — Data layer
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Auth — Domain layer
import '../../features/auth/domain/repositories/auth_repository.dart';

// Auth — Presentation
import '../../features/auth/presentation/manager/auth_bloc.dart';

// Use Cases
import '../usecases/login_use_case.dart';
import '../usecases/register_use_case.dart';

// Network
import '../services/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Core: Network
  // ==========================================
  sl.registerLazySingleton(() => NetworkService());

  // ==========================================
  // Feature: Auth
  // ==========================================
  sl.registerFactory(
        () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl<NetworkService>().dio),
  );
}