import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadFileToServer(File file, String action);

  Future<String> checkJobStatus(String jobId);

  Future<String> getJobResult(String jobId);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final NetworkService networkService;
  int _mockPollingCount = 0;

  UploadRemoteDataSourceImpl({required this.networkService});

  @override
  Future<String> uploadFileToServer(File file, String action) async {
    // ================== MOCK CODE ==================
    print("🚀 [MOCK] Uploading file to server...");
    await Future.delayed(const Duration(seconds: 2));
    String fakeJobId = "job_98765_ai";
    print("✅ [MOCK] Upload Success! Received Job ID: $fakeJobId");

    _mockPollingCount = 0;
    return fakeJobId;

    // ================== REAL CODE ==================
    /*
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
        "action": action,
      });

      final response = await networkService.dio.post('/upload', data: formData);
      return response.data['job_id'].toString();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
    */
  }

  @override
  Future<String> checkJobStatus(String jobId) async {
    // ================== MOCK CODE ==================
    _mockPollingCount++;
    print(
        "🔍 [MOCK] Checking status for $jobId (Attempt $_mockPollingCount)...");
    await Future.delayed(const Duration(seconds: 1));

    if (_mockPollingCount < 3) {
      print("⏳ [MOCK] Status: pending");
      return 'pending';
    } else {
      print("🎉 [MOCK] Status: completed");
      return 'completed';
    }
    // ================== REAL CODE ==================
    /*
    try {
      final response = await networkService.dio.get('/status/$jobId');
      return response.data['status'].toString();
    } catch (e) {
      throw Exception('Failed to check status: $e');
    }
    */
  }

  @override
  Future<String> getJobResult(String jobId) async {
    // ================== MOCK CODE ==================
    print("📥 [MOCK] Fetching final result for $jobId...");
    await Future.delayed(const Duration(seconds: 1));

    return "This is the AI-generated result (Summarize/Flashcards) for your file!";

    // ================== REAL CODE ==================
    /*
    try {
      final response = await networkService.dio.get('/result/$jobId');
      return response.data['data'].toString();
    } catch (e) {
      throw Exception('Failed to fetch result: $e');
    }
    */
  }
}
