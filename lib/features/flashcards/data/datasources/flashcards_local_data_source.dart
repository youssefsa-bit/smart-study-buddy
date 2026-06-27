import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';

abstract class FlashcardsLocalDataSource {
  Future<void> cacheFlashcards(int resultId, List<FlashcardModel> flashcards);
  Future<List<FlashcardModel>?> getCachedFlashcards(int resultId);
}

class FlashcardsLocalDataSourceImpl implements FlashcardsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachePrefix = 'CACHED_FLASHCARDS_';
  static const String cacheKeysList = 'CACHED_FLASHCARDS_KEYS';
  static const int maxCacheSize = 10;

  FlashcardsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheFlashcards(int resultId, List<FlashcardModel> flashcards) async {
    final key = '$cachePrefix$resultId';
    final jsonString = json.encode(flashcards.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(key, jsonString);
    List<String> keys = sharedPreferences.getStringList(cacheKeysList) ?? [];
    if (!keys.contains(key)) {
      keys.add(key);
      if (keys.length > maxCacheSize) {
        final keyToRemove = keys.removeAt(0);
        await sharedPreferences.remove(keyToRemove);
      }
      await sharedPreferences.setStringList(cacheKeysList, keys);
    }
  }

  @override
  Future<List<FlashcardModel>?> getCachedFlashcards(int resultId) async {
    final key = '$cachePrefix$resultId';
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded
            .map((e) => FlashcardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
