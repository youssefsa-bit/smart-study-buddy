import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/features/history/domain/usecases/delete_history_usecase.dart';

// ==========================================
// Auth Feature Imports
// ==========================================
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/manager/auth_bloc.dart';
// ==========================================
// Flashcards Feature Imports
// ==========================================
import '../../features/flashcards/data/datasources/flashcard_remote_data_source.dart';
import '../../features/flashcards/data/repositories/flashcard_repository_impl.dart';
import '../../features/flashcards/domain/repositories/flashcard_repository.dart';
import '../../features/flashcards/domain/usecases/get_existing_flashcards_usecase.dart';
import '../../features/flashcards/domain/usecases/get_flashcards_usecase.dart';
import '../../features/flashcards/presentation/manager/flashcard_bloc.dart';
import '../../features/flashcards/data/datasources/flashcards_local_data_source.dart';
// ==========================================
// History Feature Imports
// ==========================================
import '../../features/history/data/datasources/history_local_data_source.dart';
import '../../features/history/data/datasources/history_remote_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';
import '../../features/history/presentation/manager/history_bloc.dart';
// ==========================================
// Home Feature Imports
// ==========================================
import '../../features/home/data/datasource/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecase/get_recent_files.dart';
import '../../features/home/presentation/manager/home_bloc.dart';
// ==========================================
// MCQ Feature Imports
// ==========================================
import '../../features/mcq/data/datasources/mcq_remote_data_source.dart';
import '../../features/mcq/data/repositories/mcq_repository_impl.dart';
import '../../features/mcq/domain/repositories/mcq_repository.dart';
import '../../features/mcq/domain/usecases/generate_quiz_usecase.dart';
import '../../features/mcq/domain/usecases/get_existing_quiz_usecase.dart';
import '../../features/mcq/presentation/manager/mcq_bloc.dart';
import '../../features/mcq/data/datasources/mcq_local_data_source.dart';
// ==========================================
// Profile Feature Imports
// ==========================================
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/logout_usecase.dart';
import '../../features/profile/domain/usecases/update_name_usecase.dart';
import '../../features/profile/presentation/manager/profile_bloc.dart';
// ==========================================
// Summary Feature Imports
// ==========================================
import '../../features/summary/data/datasources/summary_remote_data_source.dart';
import '../../features/summary/data/repositories/summary_repository_impl.dart';
import '../../features/summary/domain/repositories/summary_repository.dart';
import '../../features/summary/domain/usecases/export_summary_pdf_usecase.dart';
import '../../features/summary/domain/usecases/get_existing_summary_usecase.dart';
import '../../features/summary/domain/usecases/get_summary_usecase.dart';
import '../../features/summary/presentation/manager/summary_bloc.dart';
import '../../features/summary/data/datasources/summary_local_data_source.dart';
// ==========================================
// Upload Feature Imports
// ==========================================
import '../../features/translation/data/datasources/translation_remote_datasource.dart';
import '../../features/translation/data/repositories/translation_repository_impl.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../../features/translation/domain/usecases/translate_text_usecase.dart';
import '../../features/translation/presentation/manager/translation_bloc.dart';
import '../../features/upload/data/datasource/upload_remote_data_source.dart';
import '../../features/upload/data/repositories/upload_repository_impl.dart';
import '../../features/upload/domain/repositories/upload_repository.dart';
import '../../features/upload/domain/usecase/get_all_pdfs_usecase.dart';
import '../../features/upload/domain/usecase/upload_file_usecase.dart';
import '../../features/upload/presentation/manager/upload_bloc.dart';
// ==========================================
// Core
// ==========================================
import '../manager/language_cubit.dart';
import '../manager/theme_cubit.dart';
import 'network_service.dart';
import 'pdf_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Core
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<NetworkService>(
      () => NetworkService(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageCubit(prefs: sl()));
  sl.registerFactory(() => ThemeCubit(prefs: sl()));
  sl.registerLazySingleton(() => PdfService());
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

  // 1. BLoC
  sl.registerFactory(() => HomeBloc(getRecentFilesUseCase: sl()));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetRecentFilesUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // ==========================================
  // Feature: Flashcards
  // ==========================================

  // 1. Bloc
  sl.registerFactory(() => FlashcardBloc(
        getFlashcardsUseCase: sl(),
        getExistingFlashcardsUseCase: sl(),
      ));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetFlashcardsUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingFlashcardsUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(sl(), sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<FlashcardRemoteDataSource>(
    () => FlashcardRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<FlashcardsLocalDataSource>(
    () => FlashcardsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  // Feature: Upload
  // ==========================================

  // 1. BLoCs
  sl.registerFactory(
    () => UploadBloc(
      uploadFileUseCase: sl(),
      getAllPdfsUseCase: sl(),
    ),
  );

  // 2. Use Cases
  sl.registerLazySingleton(() => UploadFileUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPdfsUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(networkService: sl()),
  );
  // ==========================================
  // Feature: Summary
  // ==========================================

  // 1. BLoC
  sl.registerFactory(() => SummaryBloc(
        getSummaryUseCase: sl(),
        getExistingSummaryUseCase: sl(),
        exportSummaryPdfUseCase: sl(),
      ));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingSummaryUseCase(sl()));
  sl.registerLazySingleton(() => ExportSummaryPdfUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<SummaryRepository>(
    () => SummaryRepositoryImpl(sl(), sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<SummaryRemoteDataSource>(
    () => SummaryRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<SummaryLocalDataSource>(
    () => SummaryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  // Feature: MCQ
  // ==========================================

  // 1. Bloc
  sl.registerFactory(
      () => McqBloc(generateQuizUseCase: sl(), getExistingQuizUseCase: sl()));

  // 2. Use Cases
  sl.registerLazySingleton(() => GenerateQuizUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingQuizUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<McqRepository>(
    () => McqRepositoryImpl(sl(), sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<McqRemoteDataSource>(
    () => McqRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<McqLocalDataSource>(
    () => McqLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  // Feature: Profile
  // ==========================================

  // 1. Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateNameUseCase: sl(),
      changePasswordUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // 2. Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNameUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(networkService: sl()),
  );

  // ==========================================
  // Feature: History
  // ==========================================
  // 1. BLoC
  sl.registerFactory(
      () => HistoryBloc(getHistoryUseCase: sl(), deleteHistoryUseCase: sl()));

  // 2. Use Cases
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHistoryUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // 4. Data Sources
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  // Feature: History
  // ==========================================
  // Data source — reuses the shared NetworkService (Dio) singleton
  sl.registerLazySingleton<TranslationRemoteDataSource>(
    () => TranslationRemoteDataSourceImpl(networkService: sl()),
  );

  // Repository
  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(remoteDataSource: sl()),
  );

  // Use case
  sl.registerLazySingleton(() => TranslateTextUseCase(sl()));

  // Bloc — factory so each screen gets a fresh instance
  sl.registerFactory(() => TranslationBloc(translateTextUseCase: sl()));
}
