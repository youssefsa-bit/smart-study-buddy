import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/processing_status_view.dart';
import '../../../../core/services/injection_container.dart';
import '../../../upload/domain/entities/upload_action.dart';
import '../manager/summary_bloc.dart';
import '../manager/summary_event.dart';
import '../manager/summary_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryScreen extends StatelessWidget {
  final String? pdfId;
  final int? resultId;
  final String fileName;
  const SummaryScreen(
      {super.key, this.pdfId, required this.fileName, this.resultId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SummaryBloc>(
      create: (context) {
        final bloc = sl<SummaryBloc>();

        if (resultId != null) {
          bloc.add(FetchExistingSummary(resultId!));
        } else if (pdfId != null) {
          bloc.add(LoadSummary(pdfId!));
        }

        return bloc;
      },
      child: Builder(
          builder: (context) {
            final loc = AppLocalizations.of(context)!;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.summaryAppbarTitle,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      fileName,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    )
                  ],
                ),
              ),
              body: BlocBuilder<SummaryBloc, SummaryState>(
                builder: (context, state) {
                  if (state is SummaryLoading) {
                    return ProcessingStatusView(
                      action: UploadAction.summarize,
                      fileName: loc.summaryGenerating,
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
                                title: loc.summaryMainTopic,
                                icon: Icons.lightbulb_outline,
                                content: summary.mainTopic,
                                isHighlight: true,
                              ),
                              const SizedBox(height: 20),
                              _buildListCard(
                                title: loc.summaryKeyConcepts,
                                icon: Icons.key_rounded,
                                items: summary.keyConcepts,
                              ),
                              const SizedBox(height: 20),
                              _buildListCard(
                                title: loc.summaryImportantDetails,
                                icon: Icons.format_list_bulleted_rounded,
                                items: summary.importantDetails,
                              ),
                              const SizedBox(height: 20),
                              _buildSectionCard(
                                title: loc.summaryConclusion,
                                icon: Icons.flag_rounded,
                                content: summary.conclusion,
                              ),
                              const SizedBox(height: 40),
                            ]),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            );
          }
      ),
    );
  }

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