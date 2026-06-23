import 'package:dio/dio.dart';
import '../../../../core/services/network_service.dart';
import '../models/mcq_model.dart';

abstract class McqRemoteDataSource {
  Future<QuizModel> generateQuiz(String pdfId, {CancelToken? cancelToken});
  Future<QuizModel> getExistingQuiz(int resultId);
}

class McqRemoteDataSourceImpl implements McqRemoteDataSource {
  final NetworkService networkService;

  McqRemoteDataSourceImpl({required this.networkService});

  @override
  Future<QuizModel> generateQuiz(String pdfId, {CancelToken? cancelToken}) async {
    try {
      final response = await networkService.dio.post(
        '/pdfs/$pdfId/quiz',
        cancelToken: cancelToken,
      );
      if (response.data['success'] == true) {
        return QuizModel.fromjson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to generate quiz');
      }
    } catch (e) {
      throw Exception('Error generating quiz: $e');
    }
  }

  @override
  Future<QuizModel> getExistingQuiz(int resultId) async {
    final response = await networkService.dio
        .get('https://snuffingly-rumless-sherita.ngrok-free.dev/api/pdfs/$resultId/quiz');
    return QuizModel.fromjson(response.data);
  }
}
