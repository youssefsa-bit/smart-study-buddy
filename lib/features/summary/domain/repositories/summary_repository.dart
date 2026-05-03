import '../entities/summary_entity.dart';

abstract class SummaryRepository {
  Future<SummaryEntity> getSummary(String pdfId);
  Future<SummaryEntity> getExistingSummary(int resultId);
}
