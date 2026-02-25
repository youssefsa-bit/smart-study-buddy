import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetFlashcardsUseCase {
  final FlashcardRepository repository;

  GetFlashcardsUseCase(this.repository);

  Future<List<Flashcard>> call() async {
    return await repository.getFlashcards();
  }
}
