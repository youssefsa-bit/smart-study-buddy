import 'package:study_buddy/features/mcq/domain/entities/mcq_entity.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel(
      {required super.id,
      required super.text,
      required super.options,
      required super.correctAnswer});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        id: json['id'] ?? 0,
        text: json['text'] ?? '',
        options: List<String>.from(json['options'] ?? []),
        correctAnswer: json['correctAnswer'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

class QuizModel extends QuizEntity {
  const QuizModel(
      {required super.quizId,
      required super.questionCount,
      required super.questions});

  factory QuizModel.fromjson(Map<String, dynamic> json) {
    final data = json['data'];
    return QuizModel(
      quizId: data['quizId'] ?? 0,
      questionCount: data['questionCount'] ?? 0,
      questions: (data['questions'] as List?)
              ?.map((q) => QuestionModel.fromJson(q))
              .toList() ??
          [],
    );
  }

  factory QuizModel.fromCachedJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quizId'] ?? 0,
      questionCount: json['questionCount'] ?? 0,
      questions: (json['questions'] as List?)
              ?.map((q) => QuestionModel.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'questionCount': questionCount,
      'questions': questions.map((q) => (q as QuestionModel).toJson()).toList(),
    };
  }
}
