import 'dart:io';

import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';
import 'package:study_buddy/features/upload/domain/repositories/upload_repository.dart';

class UploadFileUseCase {
  final UploadRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call({required File file, required UploadAction action}) async {
    return await repository.uploadFile(file, action);
  }
}
