import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color bgColor = AppColors.surfaceHighlight;
    Color labelColor = AppColors.textSecondary;

    if (isCorrect) {
      borderColor = Colors.greenAccent;
      bgColor = Colors.green.withValues(alpha: 0.15);
      labelColor = Colors.greenAccent;
    } else if (isWrong) {
      borderColor = Colors.redAccent;
      bgColor = Colors.red.withValues(alpha: 0.15);
      labelColor = Colors.redAccent;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCorrect ? Colors.greenAccent.withValues(alpha: 0.2) : (isWrong ? Colors.redAccent.withValues(alpha: 0.2) : AppColors.border),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            ),
            if (isCorrect)
              const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
            if (isWrong)
              const Icon(Icons.cancel_outlined, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
