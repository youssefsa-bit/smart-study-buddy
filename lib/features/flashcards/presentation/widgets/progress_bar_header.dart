import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProgressBarHeader extends StatelessWidget {
  const ProgressBarHeader({super.key, this.currentCard = 1});
  final double currentCard;
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: currentCard,
      backgroundColor: AppColors.surfaceHighlight,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
