import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import '../../domain/entities/pdf_file_entity.dart';
import '../../domain/usecase/get_all_pdfs_usecase.dart';
import '../../domain/usecase/upload_file_usecase.dart';
import '../../data/datasource/upload_remote_data_source.dart';
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
        isDuplicate: false,
      ));
    });
    on<PickFileEvent>((event, emit) async {
      try {
        final bytes = await event.file.readAsBytes();
        final digest = sha256.convert(bytes).toString();
        final pickedName =  p.basename(event.file.path);

        PdfFileEntity? match;
        for (var f in state.libraryFiles) {
          if (f.hash != null && f.hash == digest) {
            match = f;
            break;
          }
        }
        
        if (match == null) {
          for (var f in state.libraryFiles) {
            if (f.fileName == pickedName) {
              match = f;
              break;
            }
          }
        }

        if (match != null && match.id.isNotEmpty) {
          emit(state.copyWith(
            clearFile: true,
            selectedPdfId: match.id,
            selectedFileName: match.fileName,
            status: UploadRequestStatus.initial,
            isDuplicate: true,
          ));

        } else {
          emit(state.copyWith(
            selectedFile: event.file,
            clearLibrary: true,
            status: UploadRequestStatus.initial,
            isDuplicate: false,
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          selectedFile: event.file,
          clearLibrary: true,
          status: UploadRequestStatus.initial,
          isDuplicate: false,
        ));
      }
    });

    on<RemoveFileEvent>((event, emit) {
      emit(state.copyWith(
        clearFile: true,
        clearLibrary: true,
        clearAction: true,
        status: UploadRequestStatus.initial,
        isDuplicate: false,
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
          isDuplicate: false,
        ));
      } on DuplicateFileException catch (e) {
        String? foundId = e.id;
        
        if ((foundId == null || foundId.isEmpty) && e.originalFilename != null) {
           final match = state.libraryFiles.firstWhere(
             (f) => f.fileName == e.originalFilename, 
             orElse: () => const PdfFileEntity(id: '', fileName: '', createdAt: '')
           );
           if (match.id.isNotEmpty) {
             foundId = match.id;
           }
        }

        if (foundId != null && foundId.isNotEmpty) {
          emit(state.copyWith(
            status: UploadRequestStatus.success,
            resultData: foundId,
            isDuplicate: true,
          ));
        } else {
          emit(state.copyWith(status: UploadRequestStatus.error, errorMessage: e.message));
        }
      } catch (e) {
        emit(state.copyWith(status: UploadRequestStatus.error, errorMessage: e.toString()));
      }
    });
  }
}
