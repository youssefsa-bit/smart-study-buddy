import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getFlashcards();
}
