import '../../../../core/services/network_service.dart';
import '../models/history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryModel>> getHistory();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final NetworkService networkService;

  HistoryRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<HistoryModel>> getHistory() async {
    try {
      final response = await networkService.dio.get(
        'http://10.0.2.2:3000/api/history',
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => HistoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }
}
