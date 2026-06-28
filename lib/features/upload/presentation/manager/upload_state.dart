import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/pdf_file_entity.dart';
import '../../domain/entities/upload_action.dart';

enum UploadRequestStatus { initial, loading, success, error }

class UploadState extends Equatable {
  final File? selectedFile;
  final String? selectedPdfId;
  final String? selectedFileName;
  final UploadAction? selectedAction;
  final UploadRequestStatus status;
  final List<PdfFileEntity> libraryFiles;
  final String? loadingMessage;
  final String? resultData;
  final String? errorMessage;
  final int currentStepIndex;
  final bool isDuplicate;

  const UploadState({
    this.selectedFile,
    this.selectedPdfId,
    this.selectedFileName,
    this.selectedAction,
    this.status = UploadRequestStatus.initial,
    this.libraryFiles = const [],
    this.loadingMessage,
    this.resultData,
    this.errorMessage,
    this.currentStepIndex = 0,
    this.isDuplicate = false,
  });

  UploadState copyWith({
    File? selectedFile,
    bool clearFile = false,
    String? selectedPdfId,
    bool clearLibrary = false,
    String? selectedFileName,
    UploadAction? selectedAction,
    bool clearAction = false,
    UploadRequestStatus? status,
    List<PdfFileEntity>? libraryFiles,
    String? loadingMessage,
    String? resultData,
    String? errorMessage,
    int? currentStepIndex,
    bool? isDuplicate,
  }) {
    return UploadState(
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),

      selectedPdfId: clearLibrary ? null : (selectedPdfId ?? this.selectedPdfId),
      selectedFileName: clearLibrary ? null : (selectedFileName ?? this.selectedFileName),

      selectedAction: clearAction ? null : (selectedAction ?? this.selectedAction),
      status: status ?? this.status,
      libraryFiles: libraryFiles ?? this.libraryFiles,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      resultData: resultData ?? this.resultData,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isDuplicate: isDuplicate ?? this.isDuplicate,
    );
  }

  @override
  List<Object?> get props => [
        selectedFile,
        selectedPdfId,
        selectedFileName,
        selectedAction,
        status,
        libraryFiles,
        loadingMessage,
        resultData,
        errorMessage,
        currentStepIndex,
        isDuplicate,
      ];
}
