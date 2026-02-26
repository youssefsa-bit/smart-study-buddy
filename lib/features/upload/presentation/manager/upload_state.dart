import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/upload_action.dart';

enum UploadRequestStatus { initial, loading, success, error }

class UploadState extends Equatable {
  final File? selectedFile;
  final UploadAction? selectedAction;
  final UploadRequestStatus status;
  final String? loadingMessage;
  final String? resultData;
  final String? errorMessage;
  final int currentStepIndex;

  const UploadState({
    this.selectedFile,
    this.selectedAction,
    this.status = UploadRequestStatus.initial,
    this.loadingMessage,
    this.resultData,
    this.errorMessage,
    this.currentStepIndex = 0,
  });

  UploadState copyWith({
    File? selectedFile,
    bool clearFile = false,
    UploadAction? selectedAction,
    UploadRequestStatus? status,
    String? loadingMessage,
    String? resultData,
    String? errorMessage,
    int? currentStepIndex,
  }) {
    return UploadState(
      selectedFile: clearFile ? null : (selectedFile ?? this.selectedFile),
      selectedAction: selectedAction ?? this.selectedAction,
      status: status ?? this.status,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      resultData: resultData ?? this.resultData,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    );
  }

  @override
  List<Object?> get props => [
        selectedFile,
        selectedAction,
        status,
        loadingMessage,
        resultData,
        errorMessage,
        currentStepIndex,
      ];
}
