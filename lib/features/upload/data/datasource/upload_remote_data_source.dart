// lib/features/upload/data/datasource/upload_remote_data_source.dart

import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadFileToServer(File file);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final NetworkService networkService;

  UploadRemoteDataSourceImpl({required this.networkService});

  @override
  Future<String> uploadFileToServer(File file) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await networkService.dio.post(
        'http://10.0.2.2:3000/api/pdfs',
        data: formData,
      );

      return response.data['data']['id'].toString();
    } catch (e) {
      throw Exception('Failed to upload PDF: $e');
    }
  }
}
