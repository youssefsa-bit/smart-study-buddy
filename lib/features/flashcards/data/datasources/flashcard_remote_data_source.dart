import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';
import '../models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  Stream<List<FlashcardModel>> generateFlashcardsStream(String pdfId, {CancelToken? cancelToken});
  Future<List<FlashcardModel>> getExistingFlashcards(int resultId);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  final NetworkService networkService;

  FlashcardRemoteDataSourceImpl({required this.networkService});

  @override
  Stream<List<FlashcardModel>> generateFlashcardsStream(String pdfId, {CancelToken? cancelToken}) async* {
    try {
      final response = await networkService.dio.post<ResponseBody>(
        '/pdfs/$pdfId/flashcards/stream',
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
          receiveTimeout: const Duration(minutes: 10),
        ),
      );

      final stream = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      String currentEvent = '';

      await for (final line in stream) {
        if (line.isEmpty) continue;

        if (line.startsWith('event:')) {
          currentEvent = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          final dataString = line.substring(5).trim();

          if (currentEvent == 'flashcards') {
            final Map<String, dynamic> jsonData = jsonDecode(dataString);
            final List<dynamic> cardsList = jsonData['flashcards'];

            yield cardsList.map((c) => FlashcardModel.fromJson(c)).toList();
          } else if (currentEvent == 'error') {
            final Map<String, dynamic> jsonData = jsonDecode(dataString);
            throw Exception(jsonData['message'] ?? 'Unknown error occurred');
          }
        }
      }
    } catch (e) {
      throw Exception('Stream failed: $e');
    }
  }

  @override
  Future<List<FlashcardModel>> getExistingFlashcards(int resultId) async {
    try {
      final response = await networkService.dio.get(
        '/pdfs/$resultId/flashcards',
      );

      final List<dynamic> flashcardsJson =
          response.data['data']['flashcards'] ?? [];

      final List<FlashcardModel> flashcards = flashcardsJson
          .map((item) => FlashcardModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return flashcards;
    } catch (e) {
      throw Exception('Failed to fetch existing flashcards: $e');
    }
  }
}
