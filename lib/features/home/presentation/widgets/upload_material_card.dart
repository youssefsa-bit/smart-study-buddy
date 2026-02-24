import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

class UploadMaterialCard extends StatelessWidget {
  final VoidCallback onTap;
   const UploadMaterialCard({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),

      child: Container(
        padding: EdgeInsets.all(AppSizes.p20),
        decoration: BoxDecoration(
            color:AppColors.darkGreen,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),

      ),
        child: Row(
          children: [
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                color: AppColors.darkBlue,
                
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primaryBlue,
                size: 30,
              ),
            ),
            AppSizes.gapH16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload your material',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.gapV8,
                  Text(
                    'PDF, lecture notes , or any document',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
