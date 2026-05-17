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

  Map<String, dynamic> toJson() => {
        'type': type,
        'resultId': resultId,
        'createdAt': createdAt.toIso8601String(),
        'pdfId': pdfId,
        'fileName': fileName,
      };

  factory HistoryModel.fromCachedJson(Map<String, dynamic> json) {
    return HistoryModel(
      type: json['type'] ?? 'UNKNOWN',
      resultId: json['resultId'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      pdfId: json['pdfId'] ?? 0,
      fileName: json['fileName'] ?? 'Unknown Document',
    );
  }
}
