import 'dart:io';

import '../entities/pdf_file_entity.dart';

abstract class UploadRepository {
  Future<String> uploadFile(File file);
  Future<List<PdfFileEntity>> getAllPdfs();

}
