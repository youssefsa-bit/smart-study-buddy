import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Stream<List<Flashcard>> generateFlashcardsStream(String pdfId);
}
