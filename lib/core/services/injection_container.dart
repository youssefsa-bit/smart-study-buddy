import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/features/history/domain/usecases/delete_history_usecase.dart';
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
import '../../features/flashcards/domain/usecases/get_existing_flashcards_usecase.dart';
import '../../features/flashcards/domain/usecases/get_flashcards_usecase.dart';
import '../../features/flashcards/presentation/manager/flashcard_bloc.dart';
import '../../features/flashcards/data/datasources/flashcards_local_data_source.dart';
import '../../features/history/data/datasources/history_local_data_source.dart';
import '../../features/history/data/datasources/history_remote_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';
import '../../features/history/presentation/manager/history_bloc.dart';
import '../../features/home/data/datasource/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecase/get_recent_files.dart';
import '../../features/home/presentation/manager/home_bloc.dart';
import '../../features/mcq/data/datasources/mcq_remote_data_source.dart';
import '../../features/mcq/data/repositories/mcq_repository_impl.dart';
import '../../features/mcq/domain/repositories/mcq_repository.dart';
import '../../features/mcq/domain/usecases/generate_quiz_usecase.dart';
import '../../features/mcq/domain/usecases/get_existing_quiz_usecase.dart';
import '../../features/mcq/presentation/manager/mcq_bloc.dart';
import '../../features/mcq/data/datasources/mcq_local_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/logout_usecase.dart';
import '../../features/profile/domain/usecases/update_name_usecase.dart';
import '../../features/profile/presentation/manager/profile_bloc.dart';
import '../../features/summary/data/datasources/summary_remote_data_source.dart';
import '../../features/summary/data/repositories/summary_repository_impl.dart';
import '../../features/summary/domain/repositories/summary_repository.dart';
import '../../features/summary/domain/usecases/export_summary_pdf_usecase.dart';
import '../../features/summary/domain/usecases/get_existing_summary_usecase.dart';
import '../../features/summary/domain/usecases/get_summary_usecase.dart';
import '../../features/summary/presentation/manager/summary_bloc.dart';
import '../../features/summary/data/datasources/summary_local_data_source.dart';
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
import '../manager/language_cubit.dart';
import '../manager/theme_cubit.dart';
import 'network_service.dart';
import 'pdf_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<NetworkService>(
      () => NetworkService(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageCubit(prefs: sl()));
  sl.registerFactory(() => ThemeCubit(prefs: sl()));
  sl.registerLazySingleton(() => PdfService());
  // ==========================================
  //Auth
  // ==========================================
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        checkAuthStatusUseCase: sl(),
      ));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<NetworkService>().dio),
  );

  // ==========================================
  //Home
  // ==========================================

  sl.registerFactory(() => HomeBloc(getRecentFilesUseCase: sl()));

  sl.registerLazySingleton(() => GetRecentFilesUseCase(sl()));

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // ==========================================
  //Flashcards
  // ==========================================

  sl.registerFactory(() => FlashcardBloc(
        getFlashcardsUseCase: sl(),
        getExistingFlashcardsUseCase: sl(),
      ));

  sl.registerLazySingleton(() => GetFlashcardsUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingFlashcardsUseCase(sl()));

  sl.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<FlashcardRemoteDataSource>(
    () => FlashcardRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<FlashcardsLocalDataSource>(
    () => FlashcardsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  //Upload
  // ==========================================

  sl.registerFactory(
    () => UploadBloc(
      uploadFileUseCase: sl(),
      getAllPdfsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => UploadFileUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPdfsUseCase(sl()));

  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(networkService: sl()),
  );
  // ==========================================
  //Summary
  // ==========================================

  sl.registerFactory(() => SummaryBloc(
        getSummaryUseCase: sl(),
        getExistingSummaryUseCase: sl(),
        exportSummaryPdfUseCase: sl(),
      ));

  sl.registerLazySingleton(() => GetSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingSummaryUseCase(sl()));
  sl.registerLazySingleton(() => ExportSummaryPdfUseCase(sl()));

  sl.registerLazySingleton<SummaryRepository>(
    () => SummaryRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<SummaryRemoteDataSource>(
    () => SummaryRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<SummaryLocalDataSource>(
    () => SummaryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  //MCQ
  // ==========================================

  sl.registerFactory(
      () => McqBloc(generateQuizUseCase: sl(), getExistingQuizUseCase: sl()));

  sl.registerLazySingleton(() => GenerateQuizUseCase(sl()));
  sl.registerLazySingleton(() => GetExistingQuizUseCase(sl()));

  sl.registerLazySingleton<McqRepository>(
    () => McqRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<McqRemoteDataSource>(
    () => McqRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<McqLocalDataSource>(
    () => McqLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  //Profile
  // ==========================================

  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateNameUseCase: sl(),
      changePasswordUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNameUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(networkService: sl()),
  );

  // ==========================================
  //History
  // ==========================================
  sl.registerFactory(
      () => HistoryBloc(getHistoryUseCase: sl(), deleteHistoryUseCase: sl()));

  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHistoryUseCase(sl()));

  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ==========================================
  //History
  // ==========================================
  sl.registerLazySingleton<TranslationRemoteDataSource>(
    () => TranslationRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => TranslateTextUseCase(sl()));

  sl.registerFactory(() => TranslationBloc(translateTextUseCase: sl()));
}
