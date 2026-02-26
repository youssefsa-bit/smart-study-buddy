import '../repositories/upload_repository.dart';

class GetJobResultUseCase {
  final UploadRepository repository;

  GetJobResultUseCase(this.repository);

  Future<String> call(String jobId) async {
    return await repository.getJobResult(jobId);
  }
}
