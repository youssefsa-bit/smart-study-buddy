import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/study_material.dart';

class RecentFileItem extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const RecentFileItem({
    super.key,
    required this.material,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.insert_drive_file_rounded;
    Color iconColor = const Color(0xFF2E8CFF);
    if (material.type == 'pdf') {
      iconData = Icons.picture_as_pdf_rounded;
      iconColor = Colors.redAccent;
    } else if (material.type == 'quiz') {
      iconData = Icons.help_outline_rounded;
      iconColor = AppColors.mcqOrange;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.p24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                  color: Color(0xff181b20),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
              child: Icon(iconData, color: iconColor, size: 30),
            ),
            AppSizes.gapH16,
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      material.title,
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSizes.gapV8,
                    Text(
                      '${material.subject} • ${_formatDate(
                          material.createdAt)}',
                      style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
            const Icon(Icons.more_vert_rounded, color: Color(0xFF6B7684)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}
