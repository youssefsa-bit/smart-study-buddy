import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import 'package:study_buddy/features/history/presentation/widgets/recent_history_section.dart';
import 'package:study_buddy/features/home/presentation/pages/upper_home.dart';
import 'package:study_buddy/features/home/presentation/widgets/study_tool_card.dart';

import '../widgets/upload_material_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToUpload;
  final VoidCallback onNavigateToHistory;
  const HomeScreen(
      {super.key,
      required this.onNavigateToUpload,
      required this.onNavigateToHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpperHome(),
                AppSizes.gapV24,
                UploadMaterialCard(onTap: onNavigateToUpload),
                AppSizes.gapV16,
                Text(
                  "Study Tools",
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 25,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold),
                ),
                AppSizes.gapV24,
                Row(
                  children: [
                    Expanded(
                        child: StudyToolCard(
                            title: 'Summarize',
                            subTitle: 'Get concise\nsummaries',
                            icon: Icons.article_rounded,
                            imageColor: AppColors.darkBlue,
                            iconColor: AppColors.primaryBlue,
                            onTap: () {})),
                    AppSizes.gapH16,
                    Expanded(
                        child: StudyToolCard(
                            title: 'FlashCards',
                            subTitle: 'Generate study\ncards',
                            icon: Icons.style_rounded,
                            imageColor: AppColors.flashcardImg,
                            iconColor: AppColors.flashcardGreen,
                            onTap: () {}))
                  ],
                ),
                AppSizes.gapV16,
                Row(
                  children: [
                    Expanded(
                        child: StudyToolCard(
                            title: 'MCQ Quiz',
                            subTitle: 'Test your\nknowledge',
                            icon: Icons.help_outline_rounded,
                            imageColor: AppColors.mcqImg,
                            iconColor: AppColors.mcqOrange,
                            onTap: () {})),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                AppSizes.gapV16,
                RecentHistorySection(
                  onDisplayAll: onNavigateToHistory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
