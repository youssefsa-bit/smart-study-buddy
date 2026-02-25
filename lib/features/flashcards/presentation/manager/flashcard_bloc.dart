import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_flashcards_usecase.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final GetFlashcardsUseCase getFlashcardsUseCase;

  FlashcardBloc({required this.getFlashcardsUseCase})
      : super(FlashcardInitial()) {
    on<LoadFlashcards>((event, emit) async {
      emit(FlashcardLoading());
      print('first');
      final result = await getFlashcardsUseCase.call();
      print('second');
      emit(FlashcardLoaded(cards: result, currentIndex: 0, isFlipped: false));
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
  }
}
