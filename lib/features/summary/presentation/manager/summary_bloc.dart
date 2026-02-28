import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_summary_usecase.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetSummaryUseCase getSummaryUseCase;
  Timer? _progressTimer;

  SummaryBloc({required this.getSummaryUseCase}) : super(SummaryInitial()) {
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
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
