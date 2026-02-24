import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

class StudyToolCard extends StatelessWidget {
  String title;
  String subTitle;
  IconData icon;
  Color imageColor;
  Color iconColor;
  VoidCallback onTap;

  StudyToolCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon,
      required this.imageColor,
      required this.iconColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: Container(
        width: double.infinity,
        height: 230,
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            shape: BoxShape.rectangle),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration:
                    BoxDecoration(color: imageColor, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 30,
                ),
              ),
              AppSizes.gapV16,
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              AppSizes.gapV8,
              Text(
                subTitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
