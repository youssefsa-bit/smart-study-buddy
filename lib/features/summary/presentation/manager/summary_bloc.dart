import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/pdf_service.dart';
import '../../domain/usecases/export_summary_pdf_usecase.dart';
import '../../domain/usecases/get_existing_summary_usecase.dart';
import '../../domain/usecases/get_summary_usecase.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetSummaryUseCase getSummaryUseCase;
  final GetExistingSummaryUseCase getExistingSummaryUseCase;
  final ExportSummaryPdfUseCase exportSummaryPdfUseCase;
  Timer? _progressTimer;

  SummaryBloc({
    required this.getSummaryUseCase,
    required this.getExistingSummaryUseCase,
    required this.exportSummaryPdfUseCase,
  }) : super(SummaryInitial()) {
    on<LoadSummary>((event, emit) async {
      int currentStep = 0;
      emit(SummaryLoading(stepIndex: currentStep));

      _progressTimer?.cancel();
      _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentStep < 3) {
          currentStep++;
          emit(SummaryLoading(stepIndex: currentStep));
        } else {
          timer.cancel();
        }
      });

      try {
        final summary = await getSummaryUseCase.call(event.pdfId);
        _progressTimer?.cancel();
        emit(SummaryLoaded(summary));
      } catch (e) {
        _progressTimer?.cancel();
        emit(SummaryError("Failed to fetch summary: $e"));
      }
    });

    on<FetchExistingSummary>((event, emit) async {
      try {
        final summary = await getExistingSummaryUseCase.call(event.resultId);
        emit(SummaryLoaded(summary));
      } catch (e) {
        emit(SummaryError("Failed to fetch existing summary: $e"));
      }
    });

    on<DownloadSummaryPdf>((event, emit) async {
      emit(SummaryPdfDownloading(event.summary));
      try {
        final savedPath = await exportSummaryPdfUseCase.call(
            event.pdfId, event.fileName);
        emit(SummaryPdfDownloaded(event.summary, savedPath));
      } catch (e) {
        emit(SummaryPdfDownloadError(
            event.summary, 'Failed to download PDF: $e'));
      }
    });
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
