import '../models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  Future<List<FlashcardModel>> getFlashcards();
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  @override
  Future<List<FlashcardModel>> getFlashcards() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<Map<String, dynamic>> mockData = [
      {
        "question": "What is Artificial Intelligence?",
        "answer":
            "A branch of computer science that focuses on creating intelligent machines."
      },
      {
        "question": "What is Flutter?",
        "answer":
            "An open-source UI software development kit created by Google."
      },
      {
        "question": "What is Clean Architecture?",
        "answer":
            "A software design philosophy that separates the elements of a design into ring levels."
      }
    ];

    return mockData.map((json) => FlashcardModel.fromJson(json)).toList();
  }
}
