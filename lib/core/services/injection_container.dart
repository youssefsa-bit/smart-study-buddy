import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/manager/auth_bloc.dart';
import '../../features/flashcards/data/datasources/flashcard_remote_data_source.dart';
import '../../features/flashcards/data/repositories/flashcard_repository_impl.dart';
import '../../features/flashcards/domain/repositories/flashcard_repository.dart';
import '../../features/flashcards/domain/usecases/get_flashcards_usecase.dart';
import '../../features/flashcards/presentation/manager/flashcard_bloc.dart';
import '../../features/home/data/datasource/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecase/get_recent_files.dart';
import '../../features/home/presentation/manager/home_bloc.dart';
// --- Upload Feature Imports ---
import '../../features/upload/data/datasource/upload_remote_data_source.dart';
import '../../features/upload/data/repositories/upload_repository_impl.dart';
import '../../features/upload/domain/repositories/upload_repository.dart';
import '../../features/upload/domain/usecase/upload_file_usecase.dart';
import '../../features/upload/presentation/manager/upload_bloc.dart';
import 'network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Core
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<NetworkService>(
      () => NetworkService(sharedPreferences: sl()));

  // ==========================================
  // Feature: Auth
  // ==========================================
  // 1. BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        checkAuthStatusUseCase: sl(),
      ));

  // 2. Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // 4. Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<NetworkService>().dio),
  );

  // ==========================================
  // Feature: Home
  // ==========================================

  // 1. Domain Layer: Use Cases
  sl.registerFactory(() => HomeBloc(getRecentFilesUseCase: sl()));
  sl.registerLazySingleton(() => GetRecentFilesUseCase(sl()));

  // 2. Data Layer: Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // 3. Data Layer: Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // ==========================================
  // Feature: Flashcards
  // ==========================================

  // 1. Presentation Layer: Bloc
  sl.registerFactory(() => FlashcardBloc(getFlashcardsUseCase: sl()));

  // 2. Domain Layer: Use Cases
  sl.registerLazySingleton(() => GetFlashcardsUseCase(sl()));

  // 3. Data Layer: Repository
  sl.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(sl()),
  );

  // 4. Data Layer: Data Sources
  sl.registerLazySingleton<FlashcardRemoteDataSource>(
    () => FlashcardRemoteDataSourceImpl(networkService: sl()),
  );

  // ==========================================
  // Feature: Upload
  // ==========================================

  // 1. BLoCs
  sl.registerFactory(
    () => UploadBloc(
      uploadFileUseCase: sl(),
    ),
  );

  // 2. Use Cases
  sl.registerLazySingleton(() => UploadFileUseCase(sl()));

  // 3. Repositories
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(networkService: sl()),
  );
}
