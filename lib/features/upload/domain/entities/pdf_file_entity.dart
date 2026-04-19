import 'package:equatable/equatable.dart';

class PdfFileEntity extends Equatable {
  final String id;
  final String fileName;
  final String createdAt;

  const PdfFileEntity(
      {required this.id, required this.fileName, required this.createdAt});

  @override
  List<Object?> get props => [id, fileName, createdAt];
}
