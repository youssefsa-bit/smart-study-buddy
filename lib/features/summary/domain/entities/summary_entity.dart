import 'package:equatable/equatable.dart';

class SummaryEntity extends Equatable {
  final String mainTopic;
  final List<String> keyConcepts;
  final List<String> importantDetails;
  final String conclusion;

  const SummaryEntity({
    required this.mainTopic,
    required this.keyConcepts,
    required this.importantDetails,
    required this.conclusion,
  });

  @override
  List<Object?> get props =>
      [mainTopic, keyConcepts, importantDetails, conclusion];
}
