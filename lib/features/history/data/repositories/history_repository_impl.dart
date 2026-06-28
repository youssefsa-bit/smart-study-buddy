import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<HistoryItem>> getHistory() async {
    try {
      final remoteItems = await remoteDataSource.getHistory();
      await localDataSource.cacheHistory(remoteItems, maxItems: 20);
      return remoteItems;
    } catch (_) {
      final cached = await localDataSource.getCachedHistory();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<void> deleteHistory(int resultId, String type) async {
    await remoteDataSource.deleteHistory(resultId, type);
    final cached = await localDataSource.getCachedHistory();
    final updated = cached
        .where((item) => !(item.resultId == resultId &&
            item.type.toUpperCase() == type.toUpperCase()))
        .toList();
    await localDataSource.cacheHistory(updated, maxItems: 20);
    await localDataSource.clearFeatureCache(resultId, type);
  }
}
