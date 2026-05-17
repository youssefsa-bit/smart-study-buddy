import '../entities/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> deleteHistory(int resultId, String type);
}
