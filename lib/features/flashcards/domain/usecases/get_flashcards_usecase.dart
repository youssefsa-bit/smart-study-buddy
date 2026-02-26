import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetFlashcardsUseCase {
  final FlashcardRepository repository;
  GetFlashcardsUseCase(this.repository);

  Stream<List<Flashcard>> call(String pdfId) {
    return repository.generateFlashcardsStream(pdfId);
  }
}
