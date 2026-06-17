import '../../domain/entities/translation.dart';

class TranslationModel extends Translation {
  const TranslationModel({
    required super.originalText,
    required super.translatedText,
    required super.targetLang,
  });

  factory TranslationModel.fromJson({
    required Map<String, dynamic> json,
    required String originalText,
    required String targetLang,
  }) {
    return TranslationModel(
      originalText: originalText,
      translatedText: json['translated'] as String,
      targetLang: targetLang,
    );
  }
}
