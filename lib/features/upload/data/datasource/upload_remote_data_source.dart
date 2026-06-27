
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';
import '../models/pdf_file_model.dart';

class DuplicateFileException implements Exception {
  final String? id;
  final String? originalFilename;
  final String message;
  DuplicateFileException({this.id, this.originalFilename, required this.message});
}

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
        '/pdfs',
        data: formData,
      );

      final String message = response.data['message']?.toString().toLowerCase() ?? '';
      if (message.contains('already') || message.contains('exist')) {
        throw DuplicateFileException(
          id: response.data['data']?['id']?.toString() ?? response.data['id']?.toString(),
          originalFilename: response.data['originalFilename']?.toString() ?? response.data['fileName']?.toString(),
          message: response.data['message'] ?? 'File already uploaded',
        );
      }

      return response.data['data']['id'].toString();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409 || e.response?.statusCode == 400) {
        final data = e.response?.data;
        if (data != null) {
          throw DuplicateFileException(
            id: data['data']?['id']?.toString() ?? data['id']?.toString() ?? data['document']?['id']?.toString(),
            originalFilename: data['originalFilename']?.toString() ?? data['fileName']?.toString(),
            message: data['message'] ?? 'File already uploaded',
          );
        }
      }
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
