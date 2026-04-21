import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetExistingFlashcardsUseCase {
  final FlashcardRepository repository;
  GetExistingFlashcardsUseCase(this.repository);

  Future<List<Flashcard>> call(int resultId) {
    return repository.getExistingFlashcards(resultId);
  }
}
