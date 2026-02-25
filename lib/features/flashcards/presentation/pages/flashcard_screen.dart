import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/control_buttons.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/progress_bar_header.dart';

import '../../../../core/services/injection_container.dart';
import '../manager/flashcard_bloc.dart';
import '../manager/flashcard_event.dart';
import '../manager/flashcard_state.dart';
import '../widgets/flashcard_view.dart';

class FlashcardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashcardBloc>(
      create: (BuildContext context) =>
          sl<FlashcardBloc>()..add(LoadFlashcards()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(Icons.arrow_back, color: AppColors.leading),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Flashcards",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Introduction to AI Lecture",
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          actions: [
            BlocBuilder<FlashcardBloc, FlashcardState>(
              builder: (context, state) {
                int current = 0;
                int total = 0;

                if (state is FlashcardLoaded) {
                  current = state.currentIndex + 1;
                  total = state.cards.length;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "$current/$total",
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              BlocBuilder<FlashcardBloc, FlashcardState>(
                builder: (context, state) {
                  double progressValue = 0;

                  if (state is FlashcardLoaded && state.cards.isNotEmpty) {
                    progressValue =
                        (state.currentIndex + 1) / (state.cards.length);
                  }

                  return ProgressBarHeader(
                    currentCard: progressValue,
                  );
                },
              ),
              Spacer(),
              BlocBuilder<FlashcardBloc, FlashcardState>(
                builder: (context, state) {
                  if (state is FlashcardLoaded) {
                    final currentCard = state.cards[state.currentIndex];

                    return FlashcardView(
                      text: state.isFlipped
                          ? currentCard.answer
                          : currentCard.question,
                      type: state.isFlipped ? "ANSWER" : "QUESTION",
                      onTap: () {
                        context.read<FlashcardBloc>().add(FlipCard());
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              Spacer(),
              BlocBuilder<FlashcardBloc, FlashcardState>(
                builder: (context, state) {
                  if (state is FlashcardLoaded) {
                    return ControlButtons(
                      onPrevious: () {
                        context.read<FlashcardBloc>().add(PreviousCard());
                      },
                      onReset: () {
                        if (state.isFlipped) {
                          context.read<FlashcardBloc>().add(FlipCard());
                        }
                      },
                      onNext: () {
                        context.read<FlashcardBloc>().add(NextCard());
                      },
                      isFirst: state.currentIndex == 0,
                      isLast: state.currentIndex == state.cards.length - 1,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              // Control Buttons
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
