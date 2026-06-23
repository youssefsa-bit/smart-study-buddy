import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/flashcards/domain/usecases/get_existing_flashcards_usecase.dart';

import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/get_flashcards_usecase.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;
  final GetExistingFlashcardsUseCase getExistingFlashcardsUseCase;
  Timer? _progressTimer;
  CancelToken? _cancelToken;

  FlashcardBloc(
      {required this.getFlashcardsUseCase,
      required this.getExistingFlashcardsUseCase})
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

      _cancelToken = CancelToken();

      try {
        List<Flashcard> accumulatedCards = [];
        List<Flashcard> reviewDeck = [];

        bool hasError = false;

        await emit.forEach<List<Flashcard>>(
          getFlashcardsUseCase.call(event.pdfId, cancelToken: _cancelToken),
          onData: (newCardsChunk) {
            if (newCardsChunk.isEmpty) return state;

            _progressTimer?.cancel();

            for (var card in newCardsChunk) {
              final diff = card.difficulty.toLowerCase();

              if (diff == 'medium') {
                reviewDeck.add(card);
              } else if (diff == 'hard') {
                reviewDeck.add(card);
                reviewDeck.add(card);
              }
            }

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
            hasError = true;
            _progressTimer?.cancel();
            return FlashcardError("Error: $error");
          },
        );

        if (hasError) return;

        if (reviewDeck.isNotEmpty) {
          reviewDeck.shuffle();
          accumulatedCards = [...accumulatedCards, ...reviewDeck];

          emit(FlashcardLoaded(
            cards: accumulatedCards,
            currentIndex: state is FlashcardLoaded
                ? (state as FlashcardLoaded).currentIndex
                : 0,
            isFlipped: state is FlashcardLoaded
                ? (state as FlashcardLoaded).isFlipped
                : false,
          ));
        }

        if (accumulatedCards.isEmpty) {
          emit(const FlashcardError("No flashcards generated."));
        }
      } on DioException catch (e) {
        _progressTimer?.cancel();
        if (CancelToken.isCancel(e)) {
          emit(const FlashcardError("Request cancelled by user."));
        } else {
          emit(FlashcardError("Failed to fetch: $e"));
        }
      } catch (e) {
        _progressTimer?.cancel();
        emit(FlashcardError("Failed to fetch: $e"));
      }
    });
    on<LoadExistingFlashcards>((event, emit) async {
      try {
        final flashcards =
            await getExistingFlashcardsUseCase.call(event.resultId);
        if (flashcards.isEmpty) {
          add(LoadFlashcards(event.resultId.toString()));
        } else {
          emit(FlashcardLoaded(cards: flashcards));
        }
      } catch (e) {
        if (e.toString().contains('404') || e.toString().contains('No flashcards found')) {
          add(LoadFlashcards(event.resultId.toString()));
        } else {
          emit(FlashcardError("Failed to fetch existing flashcards: $e"));
        }
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
    _cancelToken?.cancel("Bloc closed");
    return super.close();
  }
}
