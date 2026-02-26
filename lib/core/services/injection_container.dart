// Create a global instance of GetIt (Our Service Locator / Waiter)
import 'package:get_it/get_it.dart';

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
import '../../features/upload/domain/usecase/check_job_status_usecase.dart';
import '../../features/upload/domain/usecase/get_job_result_usecase.dart';
import '../../features/upload/domain/usecase/upload_file_usecase.dart';
import '../../features/upload/presentation/manager/upload_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Feature: Home
  // ==========================================

  // 1. Domain Layer: Use Cases
  // We register the UseCase and tell it to get the Repository from GetIt (sl())

  //BloCs
  sl.registerFactory(() => HomeBloc(getRecentFilesUseCase: sl()));

  //Use Cases
  sl.registerLazySingleton(() => GetRecentFilesUseCase(sl()));

  // 2. Data Layer: Repository
  // When the UseCase asks for 'HomeRepository' (Interface),
  // GetIt will give it 'HomeRepositoryImpl' (Implementation).

  //Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // 3. Data Layer: Data Sources
  // When the Repository asks for the remote data source, GetIt provides it.

  //Data Sources
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
    () => FlashcardRemoteDataSourceImpl(),
  );
  // Note: We will add the HomeBloc here later once we create it in the Presentation layer!
  // ==========================================
  // Feature: Upload
  // ==========================================
  // 1. BLoCs
  sl.registerFactory(
    () => UploadBloc(
      uploadFileUseCase: sl(),
      checkJobStatusUseCase: sl(),
      getJobResultUseCase: sl(),
    ),
  );

  // 2. Use Cases
  sl.registerLazySingleton(() => UploadFileUseCase(sl()));
  sl.registerLazySingleton(() => CheckJobStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetJobResultUseCase(sl()));

  // 3. Repositories
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(networkService: sl()),
  );
}
