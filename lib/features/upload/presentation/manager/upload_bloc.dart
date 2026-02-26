import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/upload_file_usecase.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFileUseCase uploadFileUseCase;

  UploadBloc({required this.uploadFileUseCase}) : super(const UploadState()) {
    on<PickFileEvent>((event, emit) {
      emit(state.copyWith(
        selectedFile: event.file,
        status: UploadRequestStatus.initial,
        errorMessage: null,
      ));
    });

    on<RemoveFileEvent>((event, emit) {
      emit(const UploadState());
    });

    on<SelectActionEvent>((event, emit) {
      emit(state.copyWith(
        selectedAction: event.action,
        status: UploadRequestStatus.initial,
      ));
    });

    on<ProcessFileEvent>((event, emit) async {
      if (state.selectedFile == null || state.selectedAction == null) {
        return;
      }

      emit(state.copyWith(
        status: UploadRequestStatus.loading,
        currentStepIndex: 0,
      ));

      try {
        final actionString = state.selectedAction!.name;

        final result = await uploadFileUseCase.call(
          state.selectedFile!,
        );

        emit(state.copyWith(
          status: UploadRequestStatus.success,
          resultData: result,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: UploadRequestStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
