import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/network_service.dart';
import '../models/summary_model.dart';

abstract class SummaryRemoteDataSource {
  Future<SummaryModel> getSummary(String pdfId);
  Future<SummaryModel> getExistingSummary(int resultId);
  Future<String> exportSummaryPdf(String pdfId, String fileName);
}

class SummaryRemoteDataSourceImpl implements SummaryRemoteDataSource {
  final NetworkService networkService;

  SummaryRemoteDataSourceImpl({required this.networkService});

  @override
  Future<SummaryModel> getSummary(String pdfId) async {
    try {
      final response = await networkService.dio.post(
        '/pdfs/$pdfId/summary',
      );
      return SummaryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load summary: $e');
    }
  }

  @override
  Future<SummaryModel> getExistingSummary(int resultId) async {
    final response = await networkService.dio
        .get('/pdfs/$resultId/summary');
    return SummaryModel.fromJson(response.data);
  }

  @override
  Future<String> exportSummaryPdf(String pdfId, String fileName) async {
    try {
      String saveDirPath = '';

      if (Platform.isAndroid) {
        saveDirPath = '/storage/emulated/0/Download';
      } else {
        final Directory? dir = await getDownloadsDirectory();
        saveDirPath = dir?.path ?? (await getApplicationDocumentsDirectory()).path;
      }

      String sanitized = fileName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(' ', '_');
      String savePath = '$saveDirPath/${sanitized}_summary.pdf';

      int counter = 1;
      while (await File(savePath).exists()) {
        savePath = '$saveDirPath/${sanitized}_summary_$counter.pdf';
        counter++;
      }

      await networkService.dio.download(
        '/pdfs/$pdfId/summary/export',
        savePath,
      );

      return savePath;
    } catch (e) {
      throw Exception('Failed to download PDF: $e');
    }
  }
}
