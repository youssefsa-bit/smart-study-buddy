import 'package:dio/dio.dart';

import '../../../../core/services/network_service.dart';
import '../models/translation_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationModel> translate({
    required String text,
    required String targetLang,
    CancelToken? cancelToken,
  });
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final NetworkService networkService;

  const TranslationRemoteDataSourceImpl({required this.networkService});

  @override
  Future<TranslationModel> translate({
    required String text,
    required String targetLang,
    CancelToken? cancelToken,
  }) async {
    final response = await networkService.dio.post(
      '/translate',
      data: {'text': text, 'targetLang': targetLang},
      cancelToken: cancelToken,
    );

    return TranslationModel.fromJson(
      json: response.data['data'] as Map<String, dynamic>,
      originalText: text,
      targetLang: targetLang,
    );
  }
}
