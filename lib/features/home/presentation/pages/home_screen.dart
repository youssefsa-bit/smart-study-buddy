import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import 'package:study_buddy/features/history/presentation/widgets/recent_history_section.dart';
import 'package:study_buddy/features/home/presentation/pages/upper_home.dart';
import 'package:study_buddy/features/home/presentation/widgets/study_tool_card.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/upload_material_card.dart';

class HomeScreen extends StatelessWidget {
  final Function({UploadAction? action}) onNavigateToUpload;
  final VoidCallback onNavigateToHistory;

  const HomeScreen({
    super.key,
    required this.onNavigateToUpload,
    required this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: AppSizes.p20,
                left: AppSizes.p20,
                right: AppSizes.p20,
                bottom: 8.0,
              ),
              child: UpperHome(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSizes.p20,
                  right: AppSizes.p20,
                  bottom: AppSizes.p20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSizes.gapV16,
                    UploadMaterialCard(onTap: onNavigateToUpload),
                    AppSizes.gapV24,
                    Text(
                      loc.studyTools,
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
                            title: loc.summarizeTitle,
                            subTitle: loc.summarizeDesc,
                            icon: Icons.article_rounded,
                            imageColor: AppColors.darkBlue,
                            iconColor: AppColors.primaryBlue,
                            onTap: () => onNavigateToUpload(
                                action: UploadAction.summarize),
                          ),
                        ),
                        AppSizes.gapH16,
                        Expanded(
                          child: StudyToolCard(
                            title: loc.mcqTitle,
                            subTitle: loc.mcqDesc,
                            icon: Icons.help_outline_rounded,
                            imageColor: AppColors.mcqImg,
                            iconColor: AppColors.mcqOrange,
                            onTap: () =>
                                onNavigateToUpload(action: UploadAction.mcq),
                          ),
                        ),
                      ],
                    ),
                    AppSizes.gapV16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: StudyToolCard(
                            title: loc.flashcardsTitle,
                            subTitle: loc.flashcardsDesc,
                            icon: Icons.style_rounded,
                            imageColor: AppColors.flashcardImg,
                            iconColor: AppColors.flashcardGreen,
                            onTap: () => onNavigateToUpload(
                                action: UploadAction.flashcards),
                          ),
                        ),
                      ],
                    ),
                    AppSizes.gapV24,
                    RecentHistorySection(
                      onDisplayAll: onNavigateToHistory,
                    ),
                    AppSizes.gapV24,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
