import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pdf_file_entity.dart';
import '../../domain/usecase/get_all_pdfs_usecase.dart';
import '../../domain/usecase/upload_file_usecase.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFileUseCase uploadFileUseCase;
  final GetAllPdfsUseCase getAllPdfsUseCase;

  UploadBloc({required this.uploadFileUseCase,required this.getAllPdfsUseCase,}) : super(const UploadState()) {
    on<LoadLibraryEvent>((event, emit) async {
      try {
        final List<PdfFileEntity> allFiles = await getAllPdfsUseCase.call();
        final Map<String, PdfFileEntity> uniqueFilesMap = {};
        for (var file in allFiles) {
          String cleanName = file.fileName.trim();
          uniqueFilesMap[cleanName] = file;
        }
        final List<PdfFileEntity> uniqueFilesList = uniqueFilesMap.values.toList();
        emit(state.copyWith(libraryFiles: uniqueFilesList));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
    on<SelectLibraryFileEvent>((event, emit) {
      emit(state.copyWith(
        clearFile: true,
        selectedPdfId: event.pdfId,
        selectedFileName: event.fileName,
        status: UploadRequestStatus.initial,
      ));
    });
    on<PickFileEvent>((event, emit) {
      emit(state.copyWith(
        selectedFile: event.file,
        clearLibrary: true,
        status: UploadRequestStatus.initial,
      ));
    });

    on<RemoveFileEvent>((event, emit) {
      emit(state.copyWith(
        clearFile: true,
        clearLibrary: true,
        status: UploadRequestStatus.initial,
      ));
    });

    on<SelectActionEvent>((event, emit) {
      emit(state.copyWith(
        selectedAction: event.action,
        status: UploadRequestStatus.initial,
      ));
    });

    on<ProcessFileEvent>((event, emit) async {
      if (state.selectedFile == null && state.selectedPdfId == null) return;
      if (state.selectedAction == null) return;

      emit(state.copyWith(status: UploadRequestStatus.loading));

      try {
        String resultId;

        if (state.selectedPdfId != null) {
          resultId = state.selectedPdfId!;
        } else {
          resultId = await uploadFileUseCase.call(state.selectedFile!);
        }

        emit(state.copyWith(
          status: UploadRequestStatus.success,
          resultData: resultId,
        ));
      } catch (e) {
        emit(state.copyWith(status: UploadRequestStatus.error, errorMessage: e.toString()));
      }
    });
  }
}
