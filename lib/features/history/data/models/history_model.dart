import '../../domain/entities/history_item.dart';

class HistoryModel extends HistoryItem {
  const HistoryModel({
    required super.type,
    required super.resultId,
    required super.createdAt,
    required super.pdfId,
    required super.fileName,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    final pdfData = json['pdf'] ?? {};
    return HistoryModel(
      type: json['type'] ?? 'UNKNOWN',
      resultId: json['resultId'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      pdfId: pdfData['id'] ?? 0,
      fileName: pdfData['fileName'] ?? 'Unknown Document',
    );
  }
}
