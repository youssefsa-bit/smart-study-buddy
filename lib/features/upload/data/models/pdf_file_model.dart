import '../../domain/entities/pdf_file_entity.dart';

class PdfFileModel extends PdfFileEntity {
  const PdfFileModel({
    required super.id,
    required super.fileName,
    required super.createdAt,
    super.hash,
  });

  factory PdfFileModel.fromJson(Map<String, dynamic> json) {
    return PdfFileModel(
      id: json['id'].toString(),
      fileName: json['fileName'] ?? 'Unknown File',
      createdAt: json['createdAt'] ?? '',
      hash: json['hash']?.toString(),
    );
  }
}
