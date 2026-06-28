import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadBox extends StatelessWidget {
  final File? selectedFile;
  final String? fileNameFromLibrary;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const UploadBox(
      {super.key,
      this.selectedFile,
      this.fileNameFromLibrary,
      required this.onPickFile,
      required this.onRemoveFile});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String? displayFileName;

    if (selectedFile != null) {
      displayFileName = selectedFile!.path.split('/').last;
    } else if (fileNameFromLibrary != null) {
      displayFileName = fileNameFromLibrary;
    }

    if (displayFileName != null) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.flashcardImg,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.flashcardGreen, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.flashcardGreen),
            ),
            AppSizes.gapH16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayFileName,
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.gapV8,
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: AppColors.flashcardGreen, size: 14),
                      AppSizes.gapH8,
                      Text(loc.uploadBoxReady,
                          style: TextStyle(
                              color: AppColors.flashcardGreen, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: onRemoveFile,
              icon: Icon(Icons.close_rounded, color: AppColors.textSecondary),
              style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceHighlight),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onPickFile,
      child: DottedBorder(
        color: AppColors.border,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(AppSizes.radiusMedium),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(Icons.upload_file_rounded,
                    color: AppColors.primaryBlue, size: 32),
              ),
              AppSizes.gapV16,
              Text(loc.uploadBoxTapToUpload,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              AppSizes.gapV8,
              Text(loc.uploadBoxPdfOnly,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              AppSizes.gapV16,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
                child: Text('PDF',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
