import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/core_widgets/processing_status_view.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/control_buttons.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/progress_bar_header.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';
import '../../../../core/services/injection_container.dart';
import '../manager/flashcard_bloc.dart';
import '../manager/flashcard_event.dart';
import '../manager/flashcard_state.dart';
import '../widgets/flashcard_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlashcardScreen extends StatelessWidget {
  final String? pdfId;
  final int? resultId;
  final String fileName;

  const FlashcardScreen(
      {super.key, this.pdfId, required this.fileName, this.resultId});

  @override
  Widget build(BuildContext context) {
    final loc=AppLocalizations.of(context)!;
    return BlocProvider<FlashcardBloc>(
      create: (BuildContext context) {
        final bloc = sl<FlashcardBloc>();

        if (resultId != null) {
          bloc.add(LoadExistingFlashcards(resultId!));
        } else if (pdfId != null) {
          bloc.add(LoadFlashcards(pdfId!));
        }

        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(loc.flashcardAppbarTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                fileName,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )
            ],
          ),
        ),
        body: BlocBuilder<FlashcardBloc, FlashcardState>(
          builder: (context, state) {
            if (state is FlashcardLoading) {
              return ProcessingStatusView(
                action: UploadAction.flashcards,
                fileName: loc.flashcardProcessing,
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
                      type: state.isFlipped ? loc.flashcardAnswerLabel : loc.flashcardQuestionLabel,
                      isQuestion: !state.isFlipped,
                      hintText: state.isFlipped
                          ? loc.flashcardTapQuestion
                          : loc.flashcardTapReveal,
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
                    AppSizes.gapV24,
                    AppSizes.gapV16,
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
