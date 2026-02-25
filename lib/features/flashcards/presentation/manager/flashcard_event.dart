abstract class FlashcardEvent {}

class LoadFlashcards extends FlashcardEvent {}

class FlipCard extends FlashcardEvent {}

class NextCard extends FlashcardEvent {}

class PreviousCard extends FlashcardEvent {}
