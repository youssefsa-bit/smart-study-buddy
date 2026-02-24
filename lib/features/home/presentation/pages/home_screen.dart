import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/utils/app_sizes.dart';
import 'package:study_buddy/features/home/presentation/manager/home_state.dart';
import 'package:study_buddy/features/home/presentation/widgets/recent_file_item.dart';
import 'package:study_buddy/features/home/presentation/widgets/study_tool_card.dart';
import 'package:study_buddy/features/home/presentation/pages/upper_home.dart';
import '../../../../core/services/injection_container.dart';
import '../manager/home_bloc.dart';
import '../manager/home_event.dart';
import '../widgets/upload_material_card.dart';

class HomeScreen extends StatelessWidget {
 final VoidCallback onNavigateToUpload;
 final VoidCallback onNavigateToHistory;
  const HomeScreen({super.key,required this.onNavigateToUpload,required this.onNavigateToHistory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(LoadRecentFilesEvent()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpperHome(),
                  AppSizes.gapV24,
                  UploadMaterialCard(onTap:onNavigateToUpload),
                  AppSizes.gapV16,
                  Text(
                    "Study Tools",
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 25,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  AppSizes.gapV24,
                  Row(
                    children: [
                      Expanded(
                          child: StudyToolCard(
                              title: 'Summarize',
                              subTitle: 'Get concise\nsummaries',
                              icon: Icons.article_rounded,
                              imageColor: AppColors.darkBlue,
                              iconColor: AppColors.primaryBlue,
                              onTap: () {})),
                      AppSizes.gapH16,
                      Expanded(
                          child: StudyToolCard(
                              title: 'FlashCards',
                              subTitle: 'Generate study\ncards',
                              icon: Icons.style_rounded,
                              imageColor: AppColors.flashcardImg,
                              iconColor: AppColors.flashcardGreen,
                              onTap: () {}))
                    ],
                  ),
                  AppSizes.gapV16,
                  Row(
                    children: [
                      Expanded(
                          child: StudyToolCard(
                              title: 'MCQ Quiz',
                              subTitle: 'Test your\nknowledge',
                              icon: Icons.help_outline_rounded,
                              imageColor: AppColors.mcqImg,
                              iconColor: AppColors.mcqOrange,
                              onTap: () {})),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  AppSizes.gapV16,
                  Row(
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 25,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed:onNavigateToHistory,
                        child: Text(
                          "See all",
                          style: TextStyle(
                              color: AppColors.primaryBlue, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  AppSizes.gapV16,
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryBlue),
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.redAccent)),
                        );
                      } else if (state is HomeLoaded) {
                        if (state.recentFiles.isEmpty) {
                          return const Center(
                              child: Text('No recent activity yet.',
                                  style: TextStyle(color: Colors.grey)));
                        }
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return AppSizes.gapV16;
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.recentFiles.length,
                          itemBuilder: (context, index) {
                            final material = state.recentFiles[index];
                            return RecentFileItem(
                              material: material,
                              onTap: () {
                                print("Opened ${material.title}");
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
