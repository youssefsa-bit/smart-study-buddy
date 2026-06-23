import 'dart:math';

import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  final String type;
  final String hintText;
  final bool isQuestion;
  final VoidCallback onTap;

  const FlashcardView({
    super.key,
    required this.text,
    required this.type,
    required this.hintText,
    required this.isQuestion,
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
              final isUnder = (ValueKey(isQuestion) != child!.key);
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
        child: _buildCardContent(key: ValueKey(isQuestion)),
      ),
    );
  }

  Widget _buildCardContent({required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: isQuestion ? AppColors.darkBlue : AppColors.flashcardImg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color:
                isQuestion ? AppColors.primaryBlue : AppColors.flashcardGreen,
            width: 1),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            type,
            style: TextStyle(
              color:
                  isQuestion ? AppColors.primaryBlue : AppColors.flashcardGreen,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hintText,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
