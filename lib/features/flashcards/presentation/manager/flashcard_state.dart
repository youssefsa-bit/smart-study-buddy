import 'package:equatable/equatable.dart';

import '../../domain/entities/flashcard.dart';

abstract class FlashcardState extends Equatable {
  const FlashcardState();

  @override
  List<Object?> get props => [];
}

class FlashcardInitial extends FlashcardState {}

class FlashcardLoading extends FlashcardState {
  final int stepIndex;

  const FlashcardLoading({this.stepIndex = 0});

  @override
  List<Object?> get props => [stepIndex];
}

class FlashcardLoaded extends FlashcardState {
  final List<Flashcard> cards;
  final int currentIndex;
  final bool isFlipped;
  final bool isStreaming;

  const FlashcardLoaded({
    required this.cards,
    this.currentIndex = 0,
    this.isFlipped = false,
    this.isStreaming = false,
  });

  FlashcardLoaded copyWith({
    List<Flashcard>? cards,
    int? currentIndex,
    bool? isFlipped,
    bool? isStreaming,
  }) {
    return FlashcardLoaded(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  @override
  List<Object?> get props => [cards, currentIndex, isFlipped, isStreaming];
}

class FlashcardError extends FlashcardState {
  final String message;
  const FlashcardError(this.message);

  @override
  List<Object?> get props => [message];
}
