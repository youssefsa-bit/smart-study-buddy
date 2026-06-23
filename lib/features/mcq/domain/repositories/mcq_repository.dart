import 'package:dio/dio.dart';
import '../entities/mcq_entity.dart';

abstract class McqRepository {
  Future<QuizEntity> generateQuiz(String pdfId, {CancelToken? cancelToken});
  Future<QuizEntity> getExistingQuiz(int resultId);
}
