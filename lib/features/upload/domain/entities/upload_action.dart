enum UploadAction {
  summarize,
  flashcards,
  mcq
}
extension UploadActionExtension on UploadAction {
  String get stringValue {
    switch (this) {
      case UploadAction.summarize:
        return 'summarize';
      case UploadAction.flashcards:
        return 'flashcards';
      case UploadAction.mcq:
        return 'mcq';
    }
  }
}