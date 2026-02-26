import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';
import '../models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  // We change the return type to a Stream that yields lists of flashcards incrementally
  Stream<List<FlashcardModel>> generateFlashcardsStream(String pdfId);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  final NetworkService networkService;

  FlashcardRemoteDataSourceImpl({required this.networkService});

  @override
  Stream<List<FlashcardModel>> generateFlashcardsStream(String pdfId) async* {
    try {
      final response = await networkService.dio.post<ResponseBody>(
        'http://10.0.2.2:3000/api/pdfs/$pdfId/flashcards/stream',
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
          }
        }
      }
    } catch (e) {
      throw Exception('Stream failed: $e');
    }
  }
}
