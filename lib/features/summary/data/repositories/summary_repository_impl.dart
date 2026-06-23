import '../../domain/entities/summary_entity.dart';
import '../../domain/repositories/summary_repository.dart';
import '../datasources/summary_local_data_source.dart';
import '../datasources/summary_remote_data_source.dart';
import '../models/summary_model.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;
  final SummaryLocalDataSource localDataSource;

  SummaryRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<SummaryEntity> getSummary(String pdfId) async {
    try {
      final summary = await remoteDataSource.getSummary(pdfId);
      await localDataSource.cacheSummary(pdfId.hashCode, summary as SummaryModel);
      return summary;
    } catch (_) {
      final cached = await localDataSource.getCachedSummary(pdfId.hashCode);
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<SummaryEntity> getExistingSummary(int resultId) async {
    try {
      final summary = await remoteDataSource.getExistingSummary(resultId);
      await localDataSource.cacheSummary(resultId, summary as SummaryModel);
      return summary;
    } catch (_) {
      final cached = await localDataSource.getCachedSummary(resultId);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<String> exportSummaryPdf(String pdfId, String fileName) async {
    return await remoteDataSource.exportSummaryPdf(pdfId, fileName);
  }
}
