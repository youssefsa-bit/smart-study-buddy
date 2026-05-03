import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Stream<List<Flashcard>> generateFlashcardsStream(String pdfId);
  Future<List<Flashcard>> getExistingFlashcards(int resultId);
}
