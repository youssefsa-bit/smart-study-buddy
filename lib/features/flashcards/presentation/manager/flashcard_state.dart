import 'package:equatable/equatable.dart';

import '../../domain/entities/flashcard.dart';

abstract class FlashcardState extends Equatable {
  const FlashcardState();

  @override
  List<Object?> get props => [];
}

class FlashcardInitial extends FlashcardState {}

class FlashcardLoading extends FlashcardState {}

class FlashcardLoaded extends FlashcardState {
  final List<Flashcard> cards;
  final int currentIndex;
  final bool isFlipped;

  const FlashcardLoaded({
    required this.cards,
    this.currentIndex = 0,
    this.isFlipped = false,
  });

  FlashcardLoaded copyWith({
    List<Flashcard>? cards,
    int? currentIndex,
    bool? isFlipped,
  }) {
    return FlashcardLoaded(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  List<Object?> get props => [cards, currentIndex, isFlipped];
}

class FlashcardError extends FlashcardState {
  final String message;
  const FlashcardError(this.message);

  @override
  List<Object?> get props => [message];
}
