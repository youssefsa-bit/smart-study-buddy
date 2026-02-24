import 'package:study_buddy/features/home/domain/entities/study_material.dart';

class StudyMaterialModel extends StudyMaterial {
  StudyMaterialModel(
      {required super.id,
      required super.title,
      required super.subject,
      required super.createdAt,
      required super.type});

  factory StudyMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialModel(
        id: json['id'] ?? '',
        title: json['title'] ?? 'Unknown title',
        subject: json['subject'] ?? 'Unknown subject',
        createdAt: DateTime.parse(json['created_at']),
        type: json['type'] ?? 'pdf');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'created_at': createdAt.toIso8601String(),
      'type': type,
    };
  }
}
