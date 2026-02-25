import 'dart:math';

import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  final String type;
  final VoidCallback onTap;

  const FlashcardView({
    super.key,
    required this.text,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(type) != child!.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt *= isUnder ? -1.0 : 1.0;

              final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;

              return Transform(
                transform: Matrix4.rotationY(value)..setEntry(3, 2, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: _buildCardContent(key: ValueKey(type)),
      ),
    );
  }

  Widget _buildCardContent({required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: type == "QUESTION" ? AppColors.darkBlue : AppColors.flashcardImg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: type == "QUESTION"
                ? AppColors.primaryBlue
                : AppColors.flashcardGreen,
            width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: TextStyle(
              color: type == "QUESTION"
                  ? AppColors.primaryBlue
                  : AppColors.flashcardGreen,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            type == "QUESTION" ? "Tap to reveal answer" : "Tap to see question",
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
