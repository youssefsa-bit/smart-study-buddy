import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/control_buttons.dart';
import 'package:study_buddy/core/core_widgets/processing_status_view.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/progress_bar_header.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';

import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../manager/flashcard_bloc.dart';
import '../manager/flashcard_event.dart';
import '../manager/flashcard_state.dart';
import '../widgets/flashcard_view.dart';

class FlashcardScreen extends StatelessWidget {
  final String pdfId;

  const FlashcardScreen({super.key, required this.pdfId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashcardBloc>(
      create: (BuildContext context) =>
          sl<FlashcardBloc>()..add(LoadFlashcards(pdfId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            color: AppColors.leading,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutesName.main,
                arguments: 1,
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Flashcards",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            BlocBuilder<FlashcardBloc, FlashcardState>(
              builder: (context, state) {
                if (state is FlashcardLoaded && state.cards.isNotEmpty) {
                  int current = state.currentIndex + 1;
                  int total = state.cards.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<FlashcardBloc, FlashcardState>(
          builder: (context, state) {
            if (state is FlashcardLoading) {
              return ProcessingStatusView(
                action: UploadAction.flashcards,
                fileName: "Processing your document...",
                currentStepIndex: state.stepIndex,
              );
            }

            if (state is FlashcardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              );
            }

            if (state is FlashcardLoaded) {
              final currentCard = state.cards[state.currentIndex];
              double progressValue =
                  (state.currentIndex + 1) / state.cards.length;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ProgressBarHeader(currentCard: progressValue),
                    const Spacer(),
                    FlashcardView(
                      text: state.isFlipped
                          ? currentCard.answer
                          : currentCard.question,
                      type: state.isFlipped ? "ANSWER" : "QUESTION",
                      onTap: () {
                        context.read<FlashcardBloc>().add(FlipCard());
                      },
                    ),
                    const Spacer(),
                    ControlButtons(
                      onPrevious: () {
                        context.read<FlashcardBloc>().add(PreviousCard());
                      },
                      onReset: () {
                        context.read<FlashcardBloc>().add(ResetFlashcards());
                      },
                      onNext: () {
                        context.read<FlashcardBloc>().add(NextCard());
                      },
                      isFirst: state.currentIndex == 0,
                      isLast: state.currentIndex == state.cards.length - 1,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
