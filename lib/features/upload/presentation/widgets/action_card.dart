import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/upload_action.dart';

class ActionCard extends StatelessWidget {
  final UploadAction action;
  final bool isSelected;
  final VoidCallback onTap;

  const ActionCard(
      {super.key,
      required this.action,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String title = '';
    String subtitle = '';
    IconData iconData = Icons.article_outlined;
    switch (action) {
      case UploadAction.summarize:
        title = loc.actionSummarize;
        subtitle = loc.actionSummarizeDesc;
        iconData = Icons.text_snippet_outlined;
        break;
      case UploadAction.flashcards:
        title = loc.actionFlashcards;
        subtitle = loc.actionFlashcardsDesc;
        iconData = Icons.style_outlined;
        break;
      case UploadAction.mcq:
        title = loc.actionMcq;
        subtitle = loc.actionMcqDesc;
        iconData = Icons.help_outline_rounded;
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.surfaceHighlight : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary,
                size: 24,
              ),
            ),
            AppSizes.gapH16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.border,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
