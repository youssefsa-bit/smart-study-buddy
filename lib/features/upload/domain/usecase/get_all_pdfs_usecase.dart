import '../entities/pdf_file_entity.dart';
import '../repositories/upload_repository.dart';

class GetAllPdfsUseCase {
  final UploadRepository repository;

  GetAllPdfsUseCase(this.repository);

  Future<List<PdfFileEntity>> call() async {
    return await repository.getAllPdfs();
  }
}
