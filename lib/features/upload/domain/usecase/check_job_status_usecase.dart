import '../repositories/upload_repository.dart';

class CheckJobStatusUseCase {
  final UploadRepository repository;

  CheckJobStatusUseCase(this.repository);

  Future<String> call(String jobId) async {
    return await repository.checkJobStatus(jobId);
  }
}
