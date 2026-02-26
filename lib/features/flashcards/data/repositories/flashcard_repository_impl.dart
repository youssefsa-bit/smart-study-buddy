import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_remote_data_source.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardRemoteDataSource remoteDataSource;

  FlashcardRepositoryImpl(this.remoteDataSource);

  @override
  @override
  Stream<List<Flashcard>> generateFlashcardsStream(String pdfId) {
    return remoteDataSource.generateFlashcardsStream(pdfId);
  }
}
