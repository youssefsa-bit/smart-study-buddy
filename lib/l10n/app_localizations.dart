import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get navUpload;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @newHereCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'New here? Create Account'**
  String get newHereCreateAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fillYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill your details'**
  String get fillYourDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @errorEmptyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get errorEmptyName;

  /// No description provided for @errorNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get errorNameShort;

  /// No description provided for @errorEmptyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get errorEmptyEmail;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorInvalidEmail;

  /// No description provided for @errorEmptyPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get errorEmptyPassword;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get errorPasswordShort;

  /// No description provided for @errorPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least 1 uppercase letter'**
  String get errorPasswordUppercase;

  /// No description provided for @errorPasswordNumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least 1 number'**
  String get errorPasswordNumber;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPassword;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @studyTools.
  ///
  /// In en, this message translates to:
  /// **'Study Tools'**
  String get studyTools;

  /// No description provided for @summarizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get summarizeTitle;

  /// No description provided for @summarizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Get concise\nsummaries'**
  String get summarizeDesc;

  /// No description provided for @flashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'FlashCards'**
  String get flashcardsTitle;

  /// No description provided for @flashcardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate study cards'**
  String get flashcardsDesc;

  /// No description provided for @mcqTitle.
  ///
  /// In en, this message translates to:
  /// **'MCQ Quiz'**
  String get mcqTitle;

  /// No description provided for @mcqDesc.
  ///
  /// In en, this message translates to:
  /// **'Test your\nknowledge'**
  String get mcqDesc;

  /// No description provided for @uploadMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your material'**
  String get uploadMaterialTitle;

  /// No description provided for @uploadMaterialDesc.
  ///
  /// In en, this message translates to:
  /// **'PDF, lecture notes, or any document'**
  String get uploadMaterialDesc;

  /// No description provided for @actionSummarize.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get actionSummarize;

  /// No description provided for @actionSummarizeDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered summary'**
  String get actionSummarizeDesc;

  /// No description provided for @actionFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get actionFlashcards;

  /// No description provided for @actionFlashcardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated cards'**
  String get actionFlashcardsDesc;

  /// No description provided for @actionMcq.
  ///
  /// In en, this message translates to:
  /// **'MCQ Quiz'**
  String get actionMcq;

  /// No description provided for @actionMcqDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice questions'**
  String get actionMcqDesc;

  /// No description provided for @uploadBoxReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to process'**
  String get uploadBoxReady;

  /// No description provided for @uploadBoxTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get uploadBoxTapToUpload;

  /// No description provided for @uploadBoxPdfOnly.
  ///
  /// In en, this message translates to:
  /// **'PDF documents only'**
  String get uploadBoxPdfOnly;

  /// No description provided for @uploadScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Material'**
  String get uploadScreenTitle;

  /// No description provided for @uploadScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your study material to get started'**
  String get uploadScreenSubtitle;

  /// No description provided for @uploadScreenProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing document...'**
  String get uploadScreenProcessing;

  /// No description provided for @uploadScreenFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadScreenFailed;

  /// No description provided for @uploadScreenOrChoose.
  ///
  /// In en, this message translates to:
  /// **'OR CHOOSE FROM LIBRARY'**
  String get uploadScreenOrChoose;

  /// No description provided for @uploadScreenChooseAction.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE AN ACTION'**
  String get uploadScreenChooseAction;

  /// No description provided for @uploadScreenProcessNow.
  ///
  /// In en, this message translates to:
  /// **'Process Now'**
  String get uploadScreenProcessNow;

  /// No description provided for @processFlashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating Flashcards'**
  String get processFlashcardsTitle;

  /// No description provided for @processSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Generating Summary'**
  String get processSummaryTitle;

  /// No description provided for @processMcqTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating MCQ Quiz'**
  String get processMcqTitle;

  /// No description provided for @stepParseDoc.
  ///
  /// In en, this message translates to:
  /// **'Parsing document...'**
  String get stepParseDoc;

  /// No description provided for @stepIdentifyConcepts.
  ///
  /// In en, this message translates to:
  /// **'Identifying concepts...'**
  String get stepIdentifyConcepts;

  /// No description provided for @stepFormQnA.
  ///
  /// In en, this message translates to:
  /// **'Forming Q&A pairs...'**
  String get stepFormQnA;

  /// No description provided for @stepGenCards.
  ///
  /// In en, this message translates to:
  /// **'Generating cards...'**
  String get stepGenCards;

  /// No description provided for @stepAnalyzeContent.
  ///
  /// In en, this message translates to:
  /// **'Analyzing content...'**
  String get stepAnalyzeContent;

  /// No description provided for @stepExtractKeys.
  ///
  /// In en, this message translates to:
  /// **'Extracting key points...'**
  String get stepExtractKeys;

  /// No description provided for @stepFinalizeSummary.
  ///
  /// In en, this message translates to:
  /// **'Finalizing summary...'**
  String get stepFinalizeSummary;

  /// No description provided for @stepFindFacts.
  ///
  /// In en, this message translates to:
  /// **'Finding testable facts...'**
  String get stepFindFacts;

  /// No description provided for @stepCreateDistractors.
  ///
  /// In en, this message translates to:
  /// **'Creating distractors...'**
  String get stepCreateDistractors;

  /// No description provided for @stepFormatQuiz.
  ///
  /// In en, this message translates to:
  /// **'Formatting quiz...'**
  String get stepFormatQuiz;

  /// No description provided for @menuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get menuEditProfile;

  /// No description provided for @menuChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get menuChangePassword;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get menuThemeMode;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get menuLogout;

  /// No description provided for @langCurrent.
  ///
  /// In en, this message translates to:
  /// **'🇬🇧 English'**
  String get langCurrent;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to enter your credentials to access your account again.'**
  String get logoutDialogContent;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update Your Details'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your name matches your academic records.'**
  String get editProfileDesc;

  /// No description provided for @editProfileNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get editProfileNameEmpty;

  /// No description provided for @editProfileConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Update'**
  String get editProfileConfirmTitle;

  /// No description provided for @editProfileConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save these changes to your profile?'**
  String get editProfileConfirmDesc;

  /// No description provided for @editProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Name updated successfully!'**
  String get editProfileSuccess;

  /// No description provided for @editProfileError.
  ///
  /// In en, this message translates to:
  /// **'Error updating name'**
  String get editProfileError;

  /// No description provided for @editProfileSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSaveBtn;

  /// No description provided for @changePassSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get changePassSecurity;

  /// No description provided for @changePassDesc.
  ///
  /// In en, this message translates to:
  /// **'Your password must be at least 8 characters and include 1 uppercase letter and 1 number.'**
  String get changePassDesc;

  /// No description provided for @changePassCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePassCurrentLabel;

  /// No description provided for @changePassCurrentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get changePassCurrentEmpty;

  /// No description provided for @changePassNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePassNewLabel;

  /// No description provided for @changePassNewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get changePassNewEmpty;

  /// No description provided for @changePassConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePassConfirmLabel;

  /// No description provided for @changePassConfirmEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get changePassConfirmEmpty;

  /// No description provided for @changePassNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePassNotMatch;

  /// No description provided for @changePassUpdateBtn.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePassUpdateBtn;

  /// No description provided for @changePassConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change your password? You will need to use the new password next time you log in.'**
  String get changePassConfirmDesc;

  /// No description provided for @changePassSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get changePassSuccess;

  /// No description provided for @changePassUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get changePassUnexpectedError;

  /// No description provided for @changePassIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The current password you entered is incorrect.'**
  String get changePassIncorrect;

  /// No description provided for @summaryAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Summary'**
  String get summaryAppbarTitle;

  /// No description provided for @summaryGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating Summary...'**
  String get summaryGenerating;

  /// No description provided for @summaryMainTopic.
  ///
  /// In en, this message translates to:
  /// **'Main Topic'**
  String get summaryMainTopic;

  /// No description provided for @summaryKeyConcepts.
  ///
  /// In en, this message translates to:
  /// **'Key Concepts'**
  String get summaryKeyConcepts;

  /// No description provided for @summaryImportantDetails.
  ///
  /// In en, this message translates to:
  /// **'Important Details'**
  String get summaryImportantDetails;

  /// No description provided for @summaryConclusion.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get summaryConclusion;

  /// No description provided for @flashcardAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcardAppbarTitle;

  /// No description provided for @flashcardProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing your document...'**
  String get flashcardProcessing;

  /// No description provided for @flashcardQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'QUESTION'**
  String get flashcardQuestionLabel;

  /// No description provided for @flashcardAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'ANSWER'**
  String get flashcardAnswerLabel;

  /// No description provided for @flashcardTapReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal answer'**
  String get flashcardTapReveal;

  /// No description provided for @flashcardTapQuestion.
  ///
  /// In en, this message translates to:
  /// **'Tap to see question'**
  String get flashcardTapQuestion;

  /// No description provided for @mcqAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'MCQ Quiz'**
  String get mcqAppbarTitle;

  /// No description provided for @mcqGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating your Quiz...'**
  String get mcqGenerating;

  /// No description provided for @mcqShowResult.
  ///
  /// In en, this message translates to:
  /// **'Show Result'**
  String get mcqShowResult;

  /// No description provided for @mcqNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get mcqNextQuestion;

  /// No description provided for @mcqPreviousQuestion.
  ///
  /// In en, this message translates to:
  /// **'Previous Question'**
  String get mcqPreviousQuestion;

  /// No description provided for @mcqResultKeepStudying.
  ///
  /// In en, this message translates to:
  /// **'Keep Studying!'**
  String get mcqResultKeepStudying;

  /// No description provided for @mcqResultScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'You scored {score} out of {total} questions correctly'**
  String mcqResultScoreLabel(int score, int total);

  /// No description provided for @mcqResultDoneBtn.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get mcqResultDoneBtn;

  /// No description provided for @historyAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyAppbarTitle;

  /// No description provided for @historyUnknownFileType.
  ///
  /// In en, this message translates to:
  /// **'Unknown file type'**
  String get historyUnknownFileType;

  /// No description provided for @historyRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get historyRecent;

  /// No description provided for @historySeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get historySeeAll;

  /// No description provided for @historyNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent history found.'**
  String get historyNoRecent;

  /// No description provided for @historyNoData.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get historyNoData;

  /// No description provided for @historyTypeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get historyTypeQuiz;

  /// No description provided for @historyTypeFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get historyTypeFlashcards;

  /// No description provided for @historyTypeSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get historyTypeSummary;

  /// No description provided for @historyTypeDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get historyTypeDocument;

  /// No description provided for @historySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by file name…'**
  String get historySearchHint;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get historyNoResults;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionExpiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired for security reasons. Please log in again to continue.'**
  String get sessionExpiredDesc;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to the server right now. Please try again later.'**
  String get errorNoConnection;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'retry'**
  String get retry;

  /// No description provided for @uploadScreenProcessingLong.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing your document and generating content... This may take a few minutes depending on the file size.'**
  String get uploadScreenProcessingLong;

  /// No description provided for @deleteHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteHistoryTitle;

  /// No description provided for @deleteHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this file?'**
  String get deleteHistoryDesc;

  /// No description provided for @deleteHistoryBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteHistoryBtn;

  /// No description provided for @historyDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get historyDeletedSuccess;

  /// No description provided for @translationTitle.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationTitle;

  /// No description provided for @pdfStudySummary.
  ///
  /// In en, this message translates to:
  /// **'Study Summary'**
  String get pdfStudySummary;

  /// No description provided for @pdfGeneratedBy.
  ///
  /// In en, this message translates to:
  /// **'Generated by Study Buddy'**
  String get pdfGeneratedBy;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
