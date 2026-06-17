import 'package:dio/dio.dart';

import '../../domain/entities/translation.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_remote_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;

  const TranslationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Translation> translate({
    required String text,
    required String targetLang,
    CancelToken? cancelToken,
  }) async {
    return remoteDataSource.translate(
      text: text,
      targetLang: targetLang,
      cancelToken: cancelToken,
    );
  }
}
