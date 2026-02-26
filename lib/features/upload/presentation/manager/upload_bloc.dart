import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/upload/domain/usecase/check_job_status_usecase.dart';
import 'package:study_buddy/features/upload/domain/usecase/get_job_result_usecase.dart';
import 'package:study_buddy/features/upload/domain/usecase/upload_file_usecase.dart';
import 'package:study_buddy/features/upload/presentation/manager/upload_event.dart';
import 'package:study_buddy/features/upload/presentation/manager/upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFileUseCase uploadFileUseCase;
  final CheckJobStatusUseCase checkJobStatusUseCase;
  final GetJobResultUseCase getJobResultUseCase;

  UploadBloc({
    required this.uploadFileUseCase,
    required this.checkJobStatusUseCase,
    required this.getJobResultUseCase,
  }) : super(const UploadState()) {
    // 1. On picking a file
    on<PickFileEvent>((event, emit) {
      emit(state.copyWith(selectedFile: event.file));
    });

    // 2. On removing the selected file
    on<RemoveFileEvent>((event, emit) {
      emit(state.copyWith(clearFile: true));
    });

    // 3. On selecting an action (Summarize, Flashcards, MCQ)
    on<SelectActionEvent>((event, emit) {
      emit(state.copyWith(selectedAction: event.action));
    });

    on<ResetUploadEvent>((event, emit) {
      emit(const UploadState());
    });

    // 4. On pressing the "Process Now" button
    on<ProcessFileEvent>((event, emit) async {
      if (state.selectedFile == null || state.selectedAction == null) return;
      try {
        // --- Stage 1: Uploading the file ---
        emit(state.copyWith(
          status: UploadRequestStatus.loading,
          currentStepIndex: 0,
        ));
        final String jobId = await uploadFileUseCase.call(
          file: state.selectedFile!,
          action: state.selectedAction!,
        );
        // --- Stage 2: Polling for status ---
        emit(state.copyWith(currentStepIndex: 1));
        bool isCompleted = false;
        int pollingAttempt = 0;

        while (!isCompleted) {
          // Wait for 3 seconds before checking again to avoid overwhelming the server
          await Future.delayed(const Duration(seconds: 3));

          final jobStatus = await checkJobStatusUseCase.call(jobId);
          pollingAttempt++;

          if (jobStatus == 'completed') {
            isCompleted = true;
            emit(state.copyWith(currentStepIndex: 3));
          } else if (jobStatus == 'failed') {
            throw Exception("AI failed to process the document.");
          } else {
            if (pollingAttempt == 2) {
              emit(state.copyWith(currentStepIndex: 2));
            }
          }
        }

        // --- Stage 3: Fetching the final result ---
        final String finalResult = await getJobResultUseCase.call(jobId);
        // --- Success Declaration ---
        emit(state.copyWith(
          status: UploadRequestStatus.success,
          resultData: finalResult,
        ));
      } catch (e) {
        // In case an error occurs at any stage
        emit(state.copyWith(
          status: UploadRequestStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
