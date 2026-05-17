import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryModel>> getCachedHistory();

  Future<void> cacheHistory(List<HistoryModel> items, {int maxItems = 20});
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  static const _cacheKey = 'CACHED_HISTORY';

  final SharedPreferences sharedPreferences;

  HistoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<HistoryModel>> getCachedHistory() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded
          .map((e) => HistoryModel.fromCachedJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cacheHistory(List<HistoryModel> items,
      {int maxItems = 20}) async {
    final toCache =
        items.length > maxItems ? items.sublist(0, maxItems) : items;
    final encoded = json.encode(toCache.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_cacheKey, encoded);
  }
}
