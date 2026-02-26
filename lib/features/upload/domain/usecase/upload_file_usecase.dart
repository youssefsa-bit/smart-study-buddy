import 'dart:io';

import '../repositories/upload_repository.dart';

class UploadFileUseCase {
  final UploadRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call(File file) async {
    return await repository.uploadFile(file);
  }
}
