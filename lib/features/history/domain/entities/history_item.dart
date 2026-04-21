import 'package:equatable/equatable.dart';

class HistoryItem extends Equatable {
  final String type;
  final int resultId;
  final DateTime createdAt;
  final int pdfId;
  final String fileName;

  const HistoryItem({
    required this.type,
    required this.resultId,
    required this.createdAt,
    required this.pdfId,
    required this.fileName,
  });

  @override
  List<Object?> get props => [type, resultId, createdAt, pdfId, fileName];
}
