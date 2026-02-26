import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';

class UploadBox extends StatelessWidget {
  final File? selectedFile;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const UploadBox(
      {super.key,
      required this.selectedFile,
      required this.onPickFile,
      required this.onRemoveFile});

  @override
  Widget build(BuildContext context) {
    if (selectedFile != null) {
      String fileName = selectedFile!.path.split('/').last;
      return Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1F16),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: const Color(0xFF00C853), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: const Color(0xFF143021),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child:
                  Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF00C853)),
            ),
            AppSizes.gapH16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.gapV8,
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Color(0xFF00C853), size: 14),
                      AppSizes.gapH8,
                      Text("Ready to process",
                          style: TextStyle(
                              color: Color(0xFF00C853), fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: onRemoveFile,
              icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7684)),
              style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1F26)),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onPickFile,
      child: DottedBorder(
        color: const Color(0xFF3A4655),
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(AppSizes.radiusMedium),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: const Color(0xFF0F141A),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A283A),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: const Icon(Icons.upload_file_rounded,
                    color: Color(0xFF2E8CFF), size: 32),
              ),
              AppSizes.gapV16,
              const Text("Tap to upload", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              AppSizes.gapV8,
              const Text("PDF documents only", style: TextStyle(color: Color(0xFF6B7684), fontSize: 13)),
              AppSizes.gapV16,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F26),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
                child: const Text('PDF', style: TextStyle(color: Color(0xFF6B7684), fontSize: 12, fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
