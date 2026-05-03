import '../entities/mcq_entity.dart';
import '../repositories/mcq_repository.dart';

class GetExistingQuizUseCase {
  final McqRepository repository;

  GetExistingQuizUseCase(this.repository);

  Future<QuizEntity> call(int resultId) async {
    return await repository.getExistingQuiz(resultId);
  }
}
