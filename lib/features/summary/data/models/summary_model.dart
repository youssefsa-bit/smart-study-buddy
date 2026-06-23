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

  factory SummaryModel.fromCachedJson(Map<String, dynamic> json) {
    return SummaryModel(
      mainTopic: json['mainTopic'] ?? '',
      keyConcepts: List<String>.from(json['keyConcepts'] ?? []),
      importantDetails: List<String>.from(json['importantDetails'] ?? []),
      conclusion: json['conclusion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainTopic': mainTopic,
      'keyConcepts': keyConcepts,
      'importantDetails': importantDetails,
      'conclusion': conclusion,
    };
  }
}
