import 'package:study_buddy/features/home/domain/entities/study_material.dart';
import 'package:study_buddy/features/home/domain/repositories/home_repository.dart';

import '../datasource/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository{
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);
  @override
  Future<List<StudyMaterial>> getRecentFiles()async {
    try {
      final remoteFiles = await remoteDataSource.getRecentFiles();
      return remoteFiles;
    } catch (e) {
      throw Exception('Failed to fetch recent files from the server.');
    }
  }
}