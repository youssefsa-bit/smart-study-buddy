import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../auth/presentation/manager/auth_bloc.dart';
import '../../../auth/presentation/manager/auth_state.dart';

class UpperHome extends StatelessWidget {
  const UpperHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSizes.gapV16,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String displayName = "StudyFlow";
                    if (state is AuthSuccess) {
                      displayName = state.name;
                    }

                    return Text(
                      displayName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 30,
                  color: AppColors.primaryBlue,
                ))
          ],
        ),
      ],
    );
  }
}
