import '../entities/summary_entity.dart';
import '../repositories/summary_repository.dart';

class GetExistingSummaryUseCase {
  final SummaryRepository repository;

  GetExistingSummaryUseCase(this.repository);

  Future<SummaryEntity> call(int resultId) async {
    return await repository.getExistingSummary(resultId);
  }
}
