import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../features/upload/domain/entities/upload_action.dart';
import '../../l10n/app_localizations.dart';

class ProcessingStatusView extends StatelessWidget {
  final UploadAction action;
  final String fileName;
  final int currentStepIndex;

  const ProcessingStatusView(
      {super.key,
      required this.action,
      required this.fileName,
      required this.currentStepIndex});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String title = "";
    IconData headerIcon = Icons.article;
    List<String> steps = [];
    switch (action) {
      case UploadAction.flashcards:
        title = loc.processFlashcardsTitle;
        headerIcon = Icons.style_outlined;
        steps = [
          loc.stepParseDoc,
          loc.stepIdentifyConcepts,
          loc.stepFormQnA,
          loc.stepGenCards
        ];
        break;
      case UploadAction.summarize:
        title = loc.processSummaryTitle;
        headerIcon = Icons.description_outlined;
        steps = [
          loc.stepParseDoc,
          loc.stepAnalyzeContent,
          loc.stepExtractKeys,
          loc.stepFinalizeSummary
        ];
        break;
      case UploadAction.mcq:
        title = loc.processMcqTitle;
        headerIcon = Icons.help_outline_rounded;
        steps = [
          loc.stepParseDoc,
          loc.stepFindFacts,
          loc.stepCreateDistractors,
          loc.stepFormatQuiz
        ];
        break;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.p20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child:
                      Icon(headerIcon, color: AppColors.primaryBlue, size: 40),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColors.flashcardGreen,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            AppSizes.gapV24,
            Text(title,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            AppSizes.gapV8,
            Text(fileName,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
            AppSizes.gapV24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                steps.length,
                (index) {
                  return _buildStepItem(index, steps[index], currentStepIndex);
                },
              ),
            ),
            if (currentStepIndex >= steps.length - 2) ...[
              AppSizes.gapV24,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  loc.uploadScreenProcessingLong,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

Widget _buildStepItem(int index, String text, int currentIndex) {
  bool isCompleted = index < currentIndex;
  bool isActive = index == currentIndex;
  Color circleColor;
  Color textColor;
  Widget insideCircle;
  if (isCompleted) {
    circleColor = Colors.green;
    textColor = AppColors.textPrimary;
    insideCircle = const Icon(Icons.check, color: Colors.white, size: 16);
  } else if (isActive) {
    circleColor = Colors.blue;
    textColor = AppColors.textPrimary;
    insideCircle = const SizedBox(
      width: 14,
      height: 14,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  } else {
    circleColor = AppColors.surfaceHighlight;
    textColor = AppColors.textSecondary;
    insideCircle = Text('${index + 1}',
        style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12));
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: insideCircle,
        ),
        AppSizes.gapH16,
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight:
                isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
