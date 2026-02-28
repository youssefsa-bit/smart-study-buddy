import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/routes/app_routes_name.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/processing_status_view.dart';
import '../../../../core/services/injection_container.dart';
import '../../../upload/domain/entities/upload_action.dart';
import '../manager/summary_bloc.dart';
import '../manager/summary_event.dart';
import '../manager/summary_state.dart';

class SummaryScreen extends StatelessWidget {
  final String pdfId;
  const SummaryScreen({super.key, required this.pdfId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SummaryBloc>(
      create: (context) => sl<SummaryBloc>()..add(LoadSummary(pdfId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            color: AppColors.leading,
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutesName.main),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Document Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        body: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            if (state is SummaryLoading) {
              return ProcessingStatusView(
                action: UploadAction.summarize,
                fileName: "Generating Summary...",
                currentStepIndex: state.stepIndex,
              );
            }

            if (state is SummaryError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.redAccent)),
              );
            }

            if (state is SummaryLoaded) {
              final summary = state.summary;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildSectionCard(
                          title: "Main Topic",
                          icon: Icons.lightbulb_outline,
                          content: summary.mainTopic,
                          isHighlight: true,
                        ),
                        const SizedBox(height: 20),
                        _buildListCard(
                          title: "Key Concepts",
                          icon: Icons.key_rounded,
                          items: summary.keyConcepts,
                        ),
                        const SizedBox(height: 20),
                        _buildListCard(
                          title: "Important Details",
                          icon: Icons.format_list_bulleted_rounded,
                          items: summary.importantDetails,
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          title: "Conclusion",
                          icon: Icons.flag_rounded,
                          content: summary.conclusion,
                        ),
                        const SizedBox(height: 40), // Bottom padding
                      ]),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Helper widget for text blocks (Main Topic & Conclusion)
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primaryBlue.withOpacity(0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isHighlight
            ? Border.all(color: AppColors.primaryBlue.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
                color: Colors.white70, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }

  // Helper widget for list items (Key Concepts & Important Details)
  Widget _buildListCard({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.circle,
                          color: AppColors.primaryBlue, size: 8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        // Stripping out the '**' from the JSON for a cleaner standard text look
                        item.replaceAll('**', ''),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15, height: 1.5),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
