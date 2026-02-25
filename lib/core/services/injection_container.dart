// Create a global instance of GetIt (Our Service Locator / Waiter)
import 'package:get_it/get_it.dart';

import '../../features/home/data/datasource/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecase/get_recent_files.dart';
import '../../features/home/presentation/manager/home_bloc.dart';
import 'network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================================
  // Core
  // ==========================================
  sl.registerLazySingleton<NetworkService>(() => NetworkService());

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

}