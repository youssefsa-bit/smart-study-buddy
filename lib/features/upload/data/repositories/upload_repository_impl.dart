import 'dart:io';

import '../../domain/entities/pdf_file_entity.dart';
import '../../domain/repositories/upload_repository.dart';
import '../datasource/upload_remote_data_source.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  UploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> uploadFile(File file) async {
    return await remoteDataSource.uploadFileToServer(file);
  }
  @override
  Future<List<PdfFileEntity>> getAllPdfs() async {
    return await remoteDataSource.getAllPdfs();
  }
}
