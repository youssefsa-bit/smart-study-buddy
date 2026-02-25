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

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Feature: Home
  // ==========================================

  // 1. Domain Layer: Use Cases
  // We register the UseCase and tell it to get the Repository from GetIt (sl())
  sl.registerFactory(() => HomeBloc(getRecentFilesUseCase: sl()));
  sl.registerLazySingleton(() => GetRecentFilesUseCase(sl()));

  // 2. Data Layer: Repository
  // When the UseCase asks for 'HomeRepository' (Interface),
  // GetIt will give it 'HomeRepositoryImpl' (Implementation).
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // 3. Data Layer: Data Sources
  // When the Repository asks for the remote data source, GetIt provides it.
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
}
