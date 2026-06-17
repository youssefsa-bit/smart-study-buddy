import 'package:dio/dio.dart';

import '../entities/translation.dart';

abstract class TranslationRepository {
  Future<Translation> translate({
    required String text,
    required String targetLang,
    CancelToken? cancelToken,
  });
}
