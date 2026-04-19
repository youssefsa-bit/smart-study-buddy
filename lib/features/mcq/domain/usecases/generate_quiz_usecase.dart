import '../entities/mcq_entity.dart';
import '../repositories/mcq_repository.dart';

class GenerateQuizUseCase {
  final McqRepository repository;

  GenerateQuizUseCase(this.repository);

  Future<QuizEntity> call(String pdfId) async {
    return await repository.generateQuiz(pdfId);
  }
}