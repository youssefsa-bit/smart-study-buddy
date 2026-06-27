import 'package:dio/dio.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_remote_data_source.dart';
import '../datasources/flashcards_local_data_source.dart';
import '../models/flashcard_model.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardRemoteDataSource remoteDataSource;
  final FlashcardsLocalDataSource localDataSource;

  FlashcardRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Stream<List<Flashcard>> generateFlashcardsStream(String pdfId, {CancelToken? cancelToken}) {
    return remoteDataSource.generateFlashcardsStream(pdfId, cancelToken: cancelToken);
  }

  @override
  Future<List<Flashcard>> getExistingFlashcards(int resultId) async {
    try {
      final flashcards = await remoteDataSource.getExistingFlashcards(resultId);
      await localDataSource.cacheFlashcards(resultId, flashcards.cast<FlashcardModel>());
      return flashcards;
    } catch (_) {
      final cached = await localDataSource.getCachedFlashcards(resultId);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
