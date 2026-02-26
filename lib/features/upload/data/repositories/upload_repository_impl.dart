import 'dart:io';

import '../../domain/repositories/upload_repository.dart';
import '../datasource/upload_remote_data_source.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  UploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> uploadFile(File file) async {
    return await remoteDataSource.uploadFileToServer(file);
  }
}
