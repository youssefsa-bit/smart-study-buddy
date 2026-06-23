import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/mcq/domain/usecases/get_existing_quiz_usecase.dart';
import 'package:study_buddy/features/mcq/presentation/manager/mcq_event.dart';

import '../../domain/usecases/generate_quiz_usecase.dart';
import 'mcq_state.dart';

class McqBloc extends Bloc<McqEvent, McqState> {
  final GenerateQuizUseCase generateQuizUseCase;
  final GetExistingQuizUseCase getExistingQuizUseCase;
  Timer? _progressTimer;
  CancelToken? _cancelToken;

  McqBloc(
      {required this.generateQuizUseCase, required this.getExistingQuizUseCase})
      : super(McqInitial()) {
    on<GenerateMcqEvent>((event, emit) async {
      int currentStep = 0;

      emit(McqLoading(stepIndex: currentStep));

      _progressTimer?.cancel();
      _progressTimer =
          Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (currentStep < 3) {
          currentStep++;
          emit(McqLoading(stepIndex: currentStep));
        } else {
          timer.cancel();
        }
      });

      _cancelToken = CancelToken();

      try {
        final quiz = await generateQuizUseCase.call(event.pdfId, cancelToken: _cancelToken);
        _progressTimer?.cancel();
        emit(McqLoaded(quiz));
      } on DioException catch (e) {
        _progressTimer?.cancel();
        if (CancelToken.isCancel(e)) {
          emit(McqError("Request cancelled by user."));
        } else {
          emit(McqError("Sorry, question creation failed.: ${e.toString()}"));
        }
      } catch (e) {
        _progressTimer?.cancel();
        emit(McqError("Sorry, question creation failed.: ${e.toString()}"));
      }
    });
    on<GetExistingMCQ>((event, emit) async {
      try {
        final quiz = await getExistingQuizUseCase.call(event.resultId);
        emit(McqLoaded(quiz));
      } catch (e) {
        if (e.toString().contains('404') || e.toString().contains('No quiz found')) {
          add(GenerateMcqEvent(event.resultId.toString()));
        } else {
          emit(McqError("Failed to fetch existing quiz: $e"));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    _cancelToken?.cancel("Bloc closed");
    return super.close();
  }
}
