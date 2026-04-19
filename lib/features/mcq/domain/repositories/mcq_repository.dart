import '../entities/mcq_entity.dart';

abstract class McqRepository {
  Future<QuizEntity> generateQuiz(String pdfId);
}