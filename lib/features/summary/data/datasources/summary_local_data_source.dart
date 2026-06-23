import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/summary_model.dart';

abstract class SummaryLocalDataSource {
  Future<void> cacheSummary(int resultId, SummaryModel summary);
  Future<SummaryModel?> getCachedSummary(int resultId);
}

class SummaryLocalDataSourceImpl implements SummaryLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachePrefix = 'CACHED_SUMMARY_';
  static const String cacheKeysList = 'CACHED_SUMMARY_KEYS';
  static const int maxCacheSize = 10;

  SummaryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSummary(int resultId, SummaryModel summary) async {
    final key = '$cachePrefix$resultId';
    final jsonString = json.encode(summary.toJson());
    await sharedPreferences.setString(key, jsonString);

    // Manage cache size
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
  Future<SummaryModel?> getCachedSummary(int resultId) async {
    final key = '$cachePrefix$resultId';
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        return SummaryModel.fromCachedJson(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
