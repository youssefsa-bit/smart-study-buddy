abstract class TranslationEvent {
  const TranslationEvent();
}

class TranslateSelected extends TranslationEvent {
  final String text;
  final String targetLang;

  const TranslateSelected({required this.text, required this.targetLang});
}

class ClearTranslation extends TranslationEvent {
  const ClearTranslation();
}
