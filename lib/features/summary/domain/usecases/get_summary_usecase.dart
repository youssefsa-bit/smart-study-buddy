import '../entities/summary_entity.dart';
import '../repositories/summary_repository.dart';

class GetSummaryUseCase {
  final SummaryRepository repository;

  GetSummaryUseCase(this.repository);

  Future<SummaryEntity> call(String pdfId) async {
    return await repository.getSummary(pdfId);
  }
}
