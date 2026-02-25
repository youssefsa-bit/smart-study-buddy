import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onReset;
  final VoidCallback onNext;
  final bool isFirst;
  final bool isLast;

  const ControlButtons({
    super.key,
    required this.onPrevious,
    required this.onReset,
    required this.onNext,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          icon: Icons.chevron_left,
          onPressed: isFirst ? null : onPrevious,
          color: AppColors.surfaceHighlight,
        ),
        const SizedBox(width: 20),
        _buildButton(
          icon: Icons.refresh,
          onPressed: onReset,
          color: AppColors.surfaceHighlight,
        ),
        const SizedBox(width: 20),
        _buildButton(
          icon: Icons.chevron_right,
          onPressed: isLast ? null : onNext,
          color: AppColors.primaryBlue,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: onPressed == null ? color.withOpacity(0.3) : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
