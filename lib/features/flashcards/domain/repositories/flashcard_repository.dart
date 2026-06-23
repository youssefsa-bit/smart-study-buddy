import 'package:dio/dio.dart';
import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Stream<List<Flashcard>> generateFlashcardsStream(String pdfId, {CancelToken? cancelToken});
  Future<List<Flashcard>> getExistingFlashcards(int resultId);
}
