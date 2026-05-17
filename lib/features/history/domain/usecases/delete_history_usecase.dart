import '../repositories/history_repository.dart';

class DeleteHistoryUseCase {
  final HistoryRepository repository;
  DeleteHistoryUseCase(this.repository);

  Future<void> call(int resultId, String type) async {
    return await repository.deleteHistory(resultId, type);
  }
}
