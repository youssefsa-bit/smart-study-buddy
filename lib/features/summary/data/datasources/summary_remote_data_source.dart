import '../../../../core/services/network_service.dart';
import '../models/summary_model.dart';

abstract class SummaryRemoteDataSource {
  Future<SummaryModel> getSummary(String pdfId);
}

class SummaryRemoteDataSourceImpl implements SummaryRemoteDataSource {
  final NetworkService networkService;

  SummaryRemoteDataSourceImpl({required this.networkService});

  @override
  Future<SummaryModel> getSummary(String pdfId) async {
    try {
      final response = await networkService.dio.post(
        'http://10.0.2.2:3000/api/pdfs/$pdfId/summary',
      );
      return SummaryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load summary: $e');
    }
  }
}
