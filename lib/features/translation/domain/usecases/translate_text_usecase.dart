import 'package:dio/dio.dart';

import '../entities/translation.dart';
import '../repositories/translation_repository.dart';

class TranslateTextUseCase {
  final TranslationRepository repository;

  const TranslateTextUseCase(this.repository);

  Future<Translation> call({
    required String text,
    required String targetLang,
    CancelToken? cancelToken,
  }) {
    return repository.translate(
      text: text,
      targetLang: targetLang,
      cancelToken: cancelToken,
    );
  }
}
