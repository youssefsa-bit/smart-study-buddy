import 'dart:io';

import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';

abstract class UploadRepository{
  Future<String>uploadFile(File file,UploadAction action);
  Future<String> checkJobStatus(String jobId);
  Future<String> getJobResult(String jobId);
}