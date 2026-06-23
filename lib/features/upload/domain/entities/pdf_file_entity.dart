import 'package:equatable/equatable.dart';

class PdfFileEntity extends Equatable {
  final String id;
  final String fileName;
  final String createdAt;
  final String? hash;

  const PdfFileEntity(
      {required this.id, required this.fileName, required this.createdAt, this.hash});

  @override
  List<Object?> get props => [id, fileName, createdAt, hash];
}
