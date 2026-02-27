import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../features/upload/domain/entities/upload_action.dart';

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
    String title = "";
    IconData headerIcon = Icons.article;
    List<String> steps = [];
    switch (action) {
      case UploadAction.flashcards:
        title = "Creating Flashcards";
        headerIcon = Icons.style_outlined;
        steps = [
          "Parsing document...",
          "Identifying concepts...",
          "Forming Q&A pairs...",
          "Generating cards..."
        ];
        break;
      case UploadAction.summarize:
        title = "Generating Summary";
        headerIcon = Icons.description_outlined;
        steps = [
          "Parsing document...",
          "Analyzing content...",
          "Extracting key points...",
          "Finalizing summary..."
        ];
        break;
      case UploadAction.mcq:
        title = "Creating MCQ Quiz";
        headerIcon = Icons.help_outline_rounded;
        steps = [
          "Parsing document...",
          "Finding testable facts...",
          "Creating distractors...",
          "Formatting quiz..."
        ];
        break;
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
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
                    color: const Color(0xFF0F1828),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: Icon(headerIcon,
                      color: const Color(0xFF2E8CFF), size: 40),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Color(0xFF00C853), shape: BoxShape.circle),
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
            )
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
    textColor = Colors.white;
    insideCircle = const Icon(Icons.check, color: Colors.white, size: 16);
  } else if (isActive) {
    circleColor = Colors.blue;
    textColor = Colors.white;
    insideCircle = Text('${index + 1}',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12));
  } else {
    circleColor = const Color(0xFF1A1F26);
    textColor = const Color(0xFF3A4655);
    insideCircle = Text('${index + 1}',
        style: const TextStyle(
            color: Color(0xFF3A4655),
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
