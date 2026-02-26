import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
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
    String title = '';
    String subtitle = '';
    IconData iconData = Icons.article_outlined;
    switch (action) {
      case UploadAction.summarize:
        title = 'Summarize';
        subtitle = 'AI-powered summary';
        iconData = Icons.text_snippet_outlined;
        break;
      case UploadAction.flashcards:
        title = 'Flashcards';
        subtitle = 'Auto-generated cards';
        iconData = Icons.style_outlined;
        break;
      case UploadAction.mcq:
        title = 'MCQ Quiz';
        subtitle = 'Practice questions';
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
          color: isSelected ? const Color(0xFF101828) : Color(0xff111216),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2E8CFF) : const Color(0xFF23303F),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff002f4d)
                    : const Color(0xff181b20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                color: isSelected
                    ? const Color(0xff0f85dc)
                    : const Color(0xff7c7f84),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
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
                  color: isSelected
                      ? const Color(0xFF2E8CFF)
                      : const Color(0xFF3A4655),
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
