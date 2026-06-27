import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String text;
  final List<String> options;
  final String correctAnswer;

  const QuestionEntity(
      {required this.id,
      required this.text,
      required this.options,
      required this.correctAnswer});

  @override
  List<Object?> get props => [id,text,options,correctAnswer];
}

class QuizEntity extends Equatable{
  final int quizId;
  final int questionCount;
  final List<QuestionEntity> questions;
  const QuizEntity({
    required this.quizId,
    required this.questionCount,
    required this.questions,
  });

  @override
  List<Object?> get props => [quizId,questionCount,questions];
}
