import '../repositories/summary_repository.dart';

class ExportSummaryPdfUseCase {
  final SummaryRepository repository;

  ExportSummaryPdfUseCase(this.repository);

  Future<String> call(String pdfId, String fileName) {
    return repository.exportSummaryPdf(pdfId, fileName);
  }
}
