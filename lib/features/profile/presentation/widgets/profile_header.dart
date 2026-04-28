import 'package:flutter/material.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.primaryBlue,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        AppSizes.gapH16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}