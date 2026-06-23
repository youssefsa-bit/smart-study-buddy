import 'package:dio/dio.dart';
import 'package:study_buddy/features/mcq/domain/entities/mcq_entity.dart';

import '../../domain/repositories/mcq_repository.dart';
import '../datasources/mcq_local_data_source.dart';
import '../datasources/mcq_remote_data_source.dart';
import '../models/mcq_model.dart';

class McqRepositoryImpl implements McqRepository {
  final McqRemoteDataSource remoteDataSource;
  final McqLocalDataSource localDataSource;

  McqRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<QuizEntity> generateQuiz(String pdfId, {CancelToken? cancelToken}) async {
    try {
      final quiz = await remoteDataSource.generateQuiz(pdfId, cancelToken: cancelToken);
      await localDataSource.cacheQuiz(pdfId.hashCode, quiz as QuizModel);
      return quiz;
    } catch (_) {
      final cached = await localDataSource.getCachedQuiz(pdfId.hashCode);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<QuizEntity> getExistingQuiz(int resultId) async {
    try {
      final quiz = await remoteDataSource.getExistingQuiz(resultId);
      await localDataSource.cacheQuiz(resultId, quiz as QuizModel);
      return quiz;
    } catch (_) {
      final cached = await localDataSource.getCachedQuiz(resultId);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
