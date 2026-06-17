import '../../domain/entities/translation.dart';

abstract class TranslationState {
  const TranslationState();
}

class TranslationInitial extends TranslationState {
  const TranslationInitial();
}

class TranslationLoading extends TranslationState {
  final String originalText;
  const TranslationLoading({required this.originalText});
}

class TranslationLoaded extends TranslationState {
  final Translation translation;
  const TranslationLoaded({required this.translation});
}

class TranslationError extends TranslationState {
  final String message;
  const TranslationError({required this.message});
}
