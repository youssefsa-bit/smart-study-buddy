import 'package:equatable/equatable.dart';

import '../../domain/entities/mcq_entity.dart';

abstract class McqState extends Equatable {
  const McqState();

  @override
  List<Object?> get props => [];
}

class McqInitial extends McqState {}

class McqLoading extends McqState {
  final int stepIndex;

  const McqLoading({this.stepIndex = 0});

  @override
  List<Object?> get props => [stepIndex];
}

class McqLoaded extends McqState {
  final QuizEntity quiz;

  const McqLoaded(this.quiz);

  @override
  List<Object?> get props => [quiz];
}

class McqError extends McqState {
  final String message;
  const McqError(this.message);

  @override
  List<Object?> get props => [message];
}
