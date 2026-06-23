import '../../../../core/services/network_service.dart';
import '../models/history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getHistory();
  Future<void> deleteHistory(int resultId, String type);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final NetworkService networkService;

  HistoryRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<HistoryModel>> getHistory() async {
    try {
      final response = await networkService.dio.get(
        'https://snuffingly-rumless-sherita.ngrok-free.dev/api/history',
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => HistoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }

  @override
  Future<void> deleteHistory(int resultId, String type) async {
    try {
      await networkService.dio.delete(
        'https://snuffingly-rumless-sherita.ngrok-free.dev/api/history/$resultId',
        queryParameters: {'type': type},
      );
    } catch (e) {
      throw Exception('Failed to delete history item: $e');
    }
  }
}
