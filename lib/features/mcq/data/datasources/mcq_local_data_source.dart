import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mcq_model.dart';

abstract class McqLocalDataSource {
  Future<void> cacheQuiz(int resultId, QuizModel quiz);
  Future<QuizModel?> getCachedQuiz(int resultId);
}

class McqLocalDataSourceImpl implements McqLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachePrefix = 'CACHED_MCQ_';
  static const String cacheKeysList = 'CACHED_MCQ_KEYS';
  static const int maxCacheSize = 10;

  McqLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheQuiz(int resultId, QuizModel quiz) async {
    final key = '$cachePrefix$resultId';
    final jsonString = json.encode(quiz.toJson());
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
  Future<QuizModel?> getCachedQuiz(int resultId) async {
    final key = '$cachePrefix$resultId';
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        return QuizModel.fromCachedJson(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
