import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/mcq/domain/usecases/get_existing_quiz_usecase.dart';
import 'package:study_buddy/features/mcq/presentation/manager/mcq_event.dart';

import '../../domain/usecases/generate_quiz_usecase.dart';
import 'mcq_state.dart';

class McqBloc extends Bloc<McqEvent, McqState> {
  final GenerateQuizUseCase generateQuizUseCase;
  final GetExistingQuizUseCase getExistingQuizUseCase;
  Timer? _progressTimer;

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

      try {
        final quiz = await generateQuizUseCase.call(event.pdfId);
        _progressTimer?.cancel();
        emit(McqLoaded(quiz));
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
        emit(McqError("Failed to fetch existing quiz: $e"));
      }
    });
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
