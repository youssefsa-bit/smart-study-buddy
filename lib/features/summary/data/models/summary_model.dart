import '../../domain/entities/summary_entity.dart';

class SummaryModel extends SummaryEntity {
  const SummaryModel({
    required super.mainTopic,
    required super.keyConcepts,
    required super.importantDetails,
    required super.conclusion,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    final summaryData = json['data']['summary'];

    return SummaryModel(
      mainTopic: summaryData['mainTopic'] ?? '',
      keyConcepts: List<String>.from(summaryData['keyConcepts'] ?? []),
      importantDetails:
          List<String>.from(summaryData['importantDetails'] ?? []),
      conclusion: summaryData['conclusion'] ?? '',
    );
  }
}
