// lib/features/upload/data/datasource/upload_remote_data_source.dart

import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';
import '../../domain/entities/pdf_file_entity.dart';
import '../models/pdf_file_model.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadFileToServer(File file);
  Future<List<PdfFileModel>> getAllPdfs();
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
  @override
  Future<List<PdfFileModel>> getAllPdfs() async {
    try {
      final response = await networkService.dio.get('/pdfs');
      final List data = response.data['data'];
      return data.map((json) => PdfFileModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to fetch library: $e");
    }
  }
}
