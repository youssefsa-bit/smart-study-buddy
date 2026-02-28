import '../../domain/entities/summary_entity.dart';
import '../../domain/repositories/summary_repository.dart';
import '../datasources/summary_remote_data_source.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;

  SummaryRepositoryImpl(this.remoteDataSource);

  @override
  Future<SummaryEntity> getSummary(String pdfId) async {
    return await remoteDataSource.getSummary(pdfId);
  }
}
