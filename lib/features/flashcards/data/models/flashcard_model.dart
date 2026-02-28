import '../../domain/entities/flashcard.dart';

class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required super.question,
    required super.answer,
    required super.difficulty,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      question: json['question'] ?? json['front'] ?? '',
      answer: json['answer'] ?? json['back'] ?? '',
      difficulty: json['difficulty'] ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'difficulty': difficulty,
    };
  }
}
