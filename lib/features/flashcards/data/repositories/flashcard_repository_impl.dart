import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_remote_data_source.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardRemoteDataSource remoteDataSource;

  FlashcardRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Flashcard>> getFlashcards() async {
    try {
      final remoteCards = await remoteDataSource.getFlashcards();
      return remoteCards;
    } catch (e) {
      throw Exception("Failed to load flashcards from AI service");
    }
  }
}
