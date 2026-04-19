import 'package:study_buddy/features/mcq/domain/entities/mcq_entity.dart';

import '../../domain/repositories/mcq_repository.dart';
import '../datasources/mcq_remote_data_source.dart';

class McqRepositoryImpl implements McqRepository{
  final McqRemoteDataSource remoteDataSource;
  McqRepositoryImpl(this.remoteDataSource);

  @override
  Future<QuizEntity> generateQuiz(String pdfId)async {
    return await remoteDataSource.generateQuiz(pdfId);
  }

}