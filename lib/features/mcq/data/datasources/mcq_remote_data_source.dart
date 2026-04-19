import '../../../../core/services/network_service.dart';
import '../models/mcq_model.dart';

abstract class McqRemoteDataSource {
  Future<QuizModel> generateQuiz(String pdfId);
}

class McqRemoteDataSourceImpl implements McqRemoteDataSource {
  final NetworkService networkService;

  McqRemoteDataSourceImpl({required this.networkService});

  @override
  Future<QuizModel> generateQuiz(String pdfId) async {
    try {
      final response = await networkService.dio.post(
        '/pdfs/$pdfId/quiz',
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
}
