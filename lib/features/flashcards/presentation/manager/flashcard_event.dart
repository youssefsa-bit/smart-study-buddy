import 'package:equatable/equatable.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object?> get props => [];
}

class LoadFlashcards extends FlashcardEvent {
  final String pdfId;

  const LoadFlashcards(this.pdfId);

  @override
  List<Object?> get props => [pdfId];
}

class FlipCard extends FlashcardEvent {}

class NextCard extends FlashcardEvent {}

class PreviousCard extends FlashcardEvent {}

class ResetFlashcards extends FlashcardEvent {}

class UpdateLoadingStep extends FlashcardEvent {
  final int stepIndex;

  const UpdateLoadingStep(this.stepIndex);

  @override
  List<Object?> get props => [stepIndex];
}
