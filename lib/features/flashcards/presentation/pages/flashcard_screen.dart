import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/core_widgets/processing_status_view.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/control_buttons.dart';
import 'package:study_buddy/features/flashcards/presentation/widgets/progress_bar_header.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';

import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/services/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../manager/flashcard_bloc.dart';
import '../manager/flashcard_event.dart';
import '../manager/flashcard_state.dart';
import '../widgets/flashcard_view.dart';

class FlashcardScreen extends StatelessWidget {
  final String? pdfId;
  final int? resultId;
  final String fileName;

  const FlashcardScreen(
      {super.key, this.pdfId, required this.fileName, this.resultId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
      child: BlocConsumer<FlashcardBloc, FlashcardState>(
        listener: (context, state) {
          if (state is FlashcardError) {
            final errorStr = state.message.toLowerCase();
            String displayMsg = state.message;
            IconData icon = Icons.error_outline_rounded;
            if (errorStr.contains('stream failed') ||
                errorStr.contains('ai service') ||
                errorStr.contains('no flashcards') ||
                errorStr.contains('500') ||
                errorStr.contains('server')){
              displayMsg = loc.errorServerOrAiFailed;
              icon = Icons.dns_rounded;
            }else if (errorStr.contains('connection') ||
                errorStr.contains('timeout') ||
                errorStr.contains('network') ||
                errorStr.contains('socket')) {
              displayMsg = loc.errorNoConnection;
              icon = Icons.wifi_off_rounded;
            }
            CustomSnackBar.show(
              context: context,
              message: displayMsg,
              isError: true,
              customIcon: icon,
            );
          }
        },
        builder: (context, state) {
          final bool isStreamingData = state is FlashcardLoading ||
              (state is FlashcardLoaded && state.isStreaming);
          return PopScope(
            canPop: !isStreamingData,
            onPopInvoked: (didPop) {
              if (didPop) return;
              if (isStreamingData) {
                CustomSnackBar.show(
                  context: context,
                  message: loc.flashcardStreamingWarning,
                  isError: false,
                  customIcon: Icons.hourglass_empty_rounded,
                );
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: !isStreamingData,
                leading: isStreamingData
                    ? const SizedBox.shrink()
                    : const BackButton(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.flashcardAppbarTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 22,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          fileName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                actions: [
                  if (state is! FlashcardLoading)
                    IconButton(
                      icon: Icon(Icons.refresh_rounded,
                          color: isStreamingData
                              ? Colors.grey
                              : AppColors.primaryBlue),
                      tooltip: loc.retry,
                      onPressed: isStreamingData
                          ? null
                          : () {
                              final idToUse = pdfId ?? resultId?.toString();
                              if (idToUse != null) {
                                context
                                    .read<FlashcardBloc>()
                                    .add(LoadFlashcards(idToUse));
                              }
                            },
                    ),
                ],
              ),
              body: Builder(
                builder: (context) {
                  if (state is FlashcardLoading) {
                    return ProcessingStatusView(
                      action: UploadAction.flashcards,
                      fileName: loc.flashcardProcessing,
                      currentStepIndex: state.stepIndex,
                    );
                  }

                  if (state is FlashcardError) {
                    final errorStr = state.message.toLowerCase();
                    String displayMsg = state.message;
                    IconData displayIcon = Icons.error_outline_rounded;

                    if (errorStr.contains('stream failed') ||
                        errorStr.contains('ai service') ||
                        errorStr.contains('no flashcards') ||
                        errorStr.contains('500') ||
                        errorStr.contains('server')) {
                      displayMsg = loc.errorServerOrAiFailed;
                      displayIcon = Icons.dns_rounded;
                    } else if (errorStr.contains('connection') ||
                        errorStr.contains('timeout') ||
                        errorStr.contains('network') ||
                        errorStr.contains('socket')) {
                      displayMsg = loc.errorNoConnection;
                      displayIcon = Icons.wifi_off_rounded;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(displayIcon,
                                size: 80, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text(
                                displayMsg,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                final idToUse = pdfId ?? resultId?.toString();
                                if (idToUse != null) {
                                  context
                                      .read<FlashcardBloc>()
                                      .add(LoadFlashcards(idToUse));
                                }
                              },
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              label: Text(loc.retry ?? 'Retry'),
                            ),
                          ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${state.currentIndex + 1} / ${state.cards.length}",
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  if (state.isStreaming) ...[
                                    const SizedBox(width: 12),
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              Icon(Icons.style_rounded,
                                  color: AppColors.primaryBlue.withValues(alpha: 0.5),
                                  size: 24),
                            ],
                          ),
                          AppSizes.gapV16,
                          ProgressBarHeader(currentCard: progressValue),
                          const Spacer(),
                          FlashcardView(
                            text: state.isFlipped
                                ? currentCard.answer
                                : currentCard.question,
                            type: state.isFlipped
                                ? loc.flashcardAnswerLabel
                                : loc.flashcardQuestionLabel,
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
                              context
                                  .read<FlashcardBloc>()
                                  .add(ResetFlashcards());
                            },
                            onNext: () {
                              context.read<FlashcardBloc>().add(NextCard());
                            },
                            isFirst: state.currentIndex == 0,
                            isLast:
                                state.currentIndex == state.cards.length - 1,
                          ),
                          AppSizes.gapV24,
                          AppSizes.gapV16,
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
