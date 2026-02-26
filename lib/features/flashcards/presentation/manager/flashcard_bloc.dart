import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/get_flashcards_usecase.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;
  Timer? _progressTimer;

  FlashcardBloc({required this.getFlashcardsUseCase})
      : super(FlashcardInitial()) {
    on<UpdateLoadingStep>((event, emit) {
      if (state is FlashcardLoading) {
        emit(FlashcardLoading(stepIndex: event.stepIndex));
      }
    });

    on<LoadFlashcards>((event, emit) async {
      int currentStep = 0;
      emit(FlashcardLoading(stepIndex: currentStep));
      _progressTimer?.cancel();
      _progressTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (currentStep < 3) {
          currentStep++;
          add(UpdateLoadingStep(currentStep));
        } else {
          timer.cancel();
        }
      });

      try {
        List<Flashcard> accumulatedCards = [];
        await emit.forEach<List<Flashcard>>(
          getFlashcardsUseCase.call(event.pdfId),
          onData: (newCardsChunk) {
            if (newCardsChunk.isEmpty) {
              return state;
            }
            _progressTimer?.cancel();
            accumulatedCards = [...accumulatedCards, ...newCardsChunk];
            return FlashcardLoaded(
              cards: accumulatedCards,
              currentIndex: state is FlashcardLoaded
                  ? (state as FlashcardLoaded).currentIndex
                  : 0,
              isFlipped: state is FlashcardLoaded
                  ? (state as FlashcardLoaded).isFlipped
                  : false,
            );
          },
          onError: (error, stackTrace) {
            return FlashcardError("Failed to fetch flashcards: $error");
          },
        );

        if (accumulatedCards.isEmpty) {
          emit(const FlashcardError(
              "No flashcards generated for this document."));
        }
      } catch (e) {
        emit(FlashcardError("Failed to fetch flashcards: $e"));
      }
    });

    on<FlipCard>((event, emit) {
      if (state is FlashcardLoaded) {
        final currentState = state as FlashcardLoaded;
        emit(currentState.copyWith(isFlipped: !currentState.isFlipped));
      }
    });

    on<NextCard>((event, emit) {
      if (state is FlashcardLoaded) {
        final currentState = state as FlashcardLoaded;
        if (currentState.currentIndex < currentState.cards.length - 1) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex + 1,
            isFlipped: false,
          ));
        }
      }
    });

    on<PreviousCard>((event, emit) {
      if (state is FlashcardLoaded) {
        final currentState = state as FlashcardLoaded;
        if (currentState.currentIndex > 0) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex - 1,
            isFlipped: false,
          ));
        }
      }
    });

    on<ResetFlashcards>((event, emit) {
      if (state is FlashcardLoaded) {
        final currentState = state as FlashcardLoaded;
        emit(FlashcardLoaded(
            cards: currentState.cards, currentIndex: 0, isFlipped: false));
      }
    });
  }
  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
