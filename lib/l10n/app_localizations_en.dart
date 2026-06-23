// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navUpload => 'Upload';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get newHereCreateAccount => 'New here? Create Account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fillYourDetails => 'Fill your details';

  @override
  String get fullName => 'Full Name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get errorEmptyName => 'Please enter your full name';

  @override
  String get errorNameShort => 'Name must be at least 3 characters';

  @override
  String get errorEmptyEmail => 'Please enter your email address';

  @override
  String get errorInvalidEmail => 'Please enter a valid email';

  @override
  String get errorEmptyPassword => 'Please enter a password';

  @override
  String get errorPasswordShort => 'Must be at least 8 characters';

  @override
  String get errorPasswordUppercase =>
      'Must contain at least 1 uppercase letter';

  @override
  String get errorPasswordNumber => 'Must contain at least 1 number';

  @override
  String get registerConfirmPassword => 'Confirm Password';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get studyTools => 'Study Tools';

  @override
  String get summarizeTitle => 'Summarize';

  @override
  String get summarizeDesc => 'Get concise\nsummaries';

  @override
  String get flashcardsTitle => 'FlashCards';

  @override
  String get flashcardsDesc => 'Generate study cards';

  @override
  String get mcqTitle => 'MCQ Quiz';

  @override
  String get mcqDesc => 'Test your\nknowledge';

  @override
  String get uploadMaterialTitle => 'Upload your material';

  @override
  String get uploadMaterialDesc => 'PDF, lecture notes, or any document';

  @override
  String get actionSummarize => 'Summarize';

  @override
  String get actionSummarizeDesc => 'AI-powered summary';

  @override
  String get actionFlashcards => 'Flashcards';

  @override
  String get actionFlashcardsDesc => 'Auto-generated cards';

  @override
  String get actionMcq => 'MCQ Quiz';

  @override
  String get actionMcqDesc => 'Practice questions';

  @override
  String get uploadBoxReady => 'Ready to process';

  @override
  String get uploadBoxTapToUpload => 'Tap to upload';

  @override
  String get uploadBoxPdfOnly => 'PDF documents only';

  @override
  String get uploadScreenTitle => 'Upload Material';

  @override
  String get uploadScreenSubtitle => 'Add your study material to get started';

  @override
  String get uploadScreenProcessing => 'Processing document...';

  @override
  String get uploadScreenFailed => 'Upload failed';

  @override
  String get uploadScreenOrChoose => 'OR CHOOSE FROM LIBRARY';

  @override
  String get uploadScreenChooseAction => 'CHOOSE AN ACTION';

  @override
  String get uploadScreenProcessNow => 'Process Now';

  @override
  String get processFlashcardsTitle => 'Creating Flashcards';

  @override
  String get processSummaryTitle => 'Generating Summary';

  @override
  String get processMcqTitle => 'Creating MCQ Quiz';

  @override
  String get stepParseDoc => 'Parsing document...';

  @override
  String get stepIdentifyConcepts => 'Identifying concepts...';

  @override
  String get stepFormQnA => 'Forming Q&A pairs...';

  @override
  String get stepGenCards => 'Generating cards...';

  @override
  String get stepAnalyzeContent => 'Analyzing content...';

  @override
  String get stepExtractKeys => 'Extracting key points...';

  @override
  String get stepFinalizeSummary => 'Finalizing summary...';

  @override
  String get stepFindFacts => 'Finding testable facts...';

  @override
  String get stepCreateDistractors => 'Creating distractors...';

  @override
  String get stepFormatQuiz => 'Formatting quiz...';

  @override
  String get menuEditProfile => 'Edit Profile';

  @override
  String get menuChangePassword => 'Change Password';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuThemeMode => 'Theme Mode';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuLogout => 'Log Out';

  @override
  String get langCurrent => '🇬🇧 English';

  @override
  String get themeDark => 'Dark';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get logoutDialogTitle => 'Log Out';

  @override
  String get logoutDialogContent =>
      'Are you sure you want to log out? You will need to enter your credentials to access your account again.';

  @override
  String get editProfileSubtitle => 'Update Your Details';

  @override
  String get editProfileDesc =>
      'Make sure your name matches your academic records.';

  @override
  String get editProfileNameEmpty => 'Name cannot be empty';

  @override
  String get editProfileConfirmTitle => 'Confirm Update';

  @override
  String get editProfileConfirmDesc =>
      'Are you sure you want to save these changes to your profile?';

  @override
  String get editProfileSuccess => 'Name updated successfully!';

  @override
  String get editProfileError => 'Error updating name';

  @override
  String get editProfileSaveBtn => 'Save Changes';

  @override
  String get changePassSecurity => 'Security';

  @override
  String get changePassDesc =>
      'Your password must be at least 8 characters and include 1 uppercase letter and 1 number.';

  @override
  String get changePassCurrentLabel => 'Current Password';

  @override
  String get changePassCurrentEmpty => 'Please enter your current password';

  @override
  String get changePassNewLabel => 'New Password';

  @override
  String get changePassNewEmpty => 'Please enter a new password';

  @override
  String get changePassConfirmLabel => 'Confirm New Password';

  @override
  String get changePassConfirmEmpty => 'Please confirm your new password';

  @override
  String get changePassNotMatch => 'Passwords do not match';

  @override
  String get changePassUpdateBtn => 'Update Password';

  @override
  String get changePassConfirmDesc =>
      'Are you sure you want to change your password? You will need to use the new password next time you log in.';

  @override
  String get changePassSuccess => 'Password changed successfully!';

  @override
  String get changePassUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get changePassIncorrect =>
      'The current password you entered is incorrect.';

  @override
  String get summaryAppbarTitle => 'Document Summary';

  @override
  String get summaryGenerating => 'Generating Summary...';

  @override
  String get summaryMainTopic => 'Main Topic';

  @override
  String get summaryKeyConcepts => 'Key Concepts';

  @override
  String get summaryImportantDetails => 'Important Details';

  @override
  String get summaryConclusion => 'Conclusion';

  @override
  String get flashcardAppbarTitle => 'Flashcards';

  @override
  String get flashcardProcessing => 'Processing your document...';

  @override
  String get flashcardQuestionLabel => 'QUESTION';

  @override
  String get flashcardAnswerLabel => 'ANSWER';

  @override
  String get flashcardTapReveal => 'Tap to reveal answer';

  @override
  String get flashcardTapQuestion => 'Tap to see question';

  @override
  String get mcqAppbarTitle => 'MCQ Quiz';

  @override
  String get mcqGenerating => 'Generating your Quiz...';

  @override
  String get mcqShowResult => 'Show Result';

  @override
  String get mcqNextQuestion => 'Next Question';

  @override
  String get mcqPreviousQuestion => 'Previous Question';

  @override
  String get mcqResultKeepStudying => 'Keep Studying!';

  @override
  String mcqResultScoreLabel(int score, int total) {
    return 'You scored $score out of $total questions correctly';
  }

  @override
  String get mcqResultDoneBtn => 'Done';

  @override
  String get historyAppbarTitle => 'History';

  @override
  String get historyUnknownFileType => 'Unknown file type';

  @override
  String get historyRecent => 'Recent';

  @override
  String get historySeeAll => 'See all';

  @override
  String get historyNoRecent => 'No recent history found.';

  @override
  String get historyNoData => 'No history yet.';

  @override
  String get historyTypeQuiz => 'Quiz';

  @override
  String get historyTypeFlashcards => 'Flashcards';

  @override
  String get historyTypeSummary => 'Summary';

  @override
  String get historyTypeDocument => 'Document';

  @override
  String get historySearchHint => 'Search by file name…';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyNoResults => 'No results found.';

  @override
  String get sessionExpiredTitle => 'Session Expired';

  @override
  String get sessionExpiredDesc =>
      'Your session has expired for security reasons. Please log in again to continue.';

  @override
  String get errorNoConnection =>
      'Cannot connect to the server right now. Please try again later.';

  @override
  String get retry => 'retry';

  @override
  String get uploadScreenProcessingLong =>
      'AI is analyzing your document and generating content... This may take a few minutes depending on the file size.';

  @override
  String get deleteHistoryTitle => 'Delete Record';

  @override
  String get deleteHistoryDesc =>
      'Are you sure you want to permanently delete this file?';

  @override
  String get deleteHistoryBtn => 'Delete';

  @override
  String get historyDeletedSuccess => 'Deleted successfully';

  @override
  String get translationTitle => 'Translation';

  @override
  String get pdfStudySummary => 'Study Summary';

  @override
  String get pdfGeneratedBy => 'Generated by Study Buddy';

  @override
  String get light => 'Light';
}
