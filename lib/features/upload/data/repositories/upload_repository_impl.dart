import 'dart:io';

import 'package:study_buddy/features/upload/data/datasource/upload_remote_data_source.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';
import 'package:study_buddy/features/upload/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository{
  final UploadRemoteDataSource remoteDataSource;
  UploadRepositoryImpl(this.remoteDataSource);
  @override
  Future<String> uploadFile(File file, UploadAction action)async {
    return await remoteDataSource.uploadFileToServer(file, action.stringValue);
  }
  @override
  Future<String> checkJobStatus(String jobId) async {
    return await remoteDataSource.checkJobStatus(jobId);
  }
  @override
  Future<String> getJobResult(String jobId) async {
    return await remoteDataSource.getJobResult(jobId);
  }
}