import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/core_widgets/processing_status_view.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../translation/presentation/manager/translation_bloc.dart';
import '../../../translation/presentation/widgets/translatable_text_wrapper.dart';
import '../../../upload/domain/entities/upload_action.dart';
import '../manager/summary_bloc.dart';
import '../manager/summary_event.dart';
import '../manager/summary_state.dart';

class SummaryScreen extends StatelessWidget {
  final String? pdfId;
  final int? resultId;
  final String fileName;
  final String translationTargetLang;

  const SummaryScreen({
    super.key,
    this.pdfId,
    required this.fileName,
    this.resultId,
    this.translationTargetLang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SummaryBloc>(
          create: (context) {
            final bloc = sl<SummaryBloc>();
            print(resultId);
            if (resultId != null) {
              bloc.add(FetchExistingSummary(resultId!));
            } else if (pdfId != null) {
              bloc.add(LoadSummary(pdfId!));
            }
            return bloc;
          },
        ),
        BlocProvider<TranslationBloc>(
          create: (_) => sl<TranslationBloc>(),
        ),
      ],
      child: Builder(builder: (context) {
        final loc = AppLocalizations.of(context)!;

        return BlocListener<SummaryBloc, SummaryState>(
          listener: (context, state) {
            if (state is SummaryPdfDownloaded) {
              final parts = state.savedPath.split(RegExp(r'[/\\]'));
              final name = parts.isNotEmpty ? parts.last : state.savedPath;
              final successMessage =
                  '${loc.downloadSuccess}\n${loc.savedAt} $name\n${state.savedPath}';
              CustomSnackBar.show(
                context: context,
                message: successMessage,
                isError: false,
                customIcon: Icons.download_done_rounded,
              );
              OpenFilex.open(state.savedPath, type: 'application/pdf').then(
                (result) {
                  if (result.type != ResultType.done) {
                    String message;
                    Color color;
                    IconData icon;

                    switch (result.type) {
                      case ResultType.noAppToOpen:
                        message = loc.errorNoPdfApp(name);
                        color = Colors.orange;
                        icon = Icons.warning_amber_rounded;
                        break;
                      case ResultType.permissionDenied:
                        message = loc.errorPermissionDenied(result.message);
                        color = Colors.redAccent;
                        icon = Icons.lock_outline_rounded;
                        break;
                      case ResultType.fileNotFound:
                        message = loc.errorFileNotFound(name);
                        color = Colors.redAccent;
                        icon = Icons.error_outline_rounded;
                        break;
                      default:
                        message = loc.errorUnexpectedOpen(result.message);
                        color = Colors.orange;
                        icon = Icons.warning_amber_rounded;
                    }

                    CustomSnackBar.show(
                      context: context,
                      message: message,
                      isError: color == Colors.redAccent,
                      customIcon: icon,
                    );
                  }
                },
              );
            } else if (state is SummaryPdfDownloadError) {
              CustomSnackBar.show(
                context: context,
                message: state.message,
                isError: true,
                customIcon: Icons.error_rounded,
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.summaryAppbarTitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    fileName,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                BlocBuilder<SummaryBloc, SummaryState>(
                  builder: (context, state) {
                    if (state is SummaryLoading) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(Icons.refresh_rounded,
                          color: AppColors.primaryBlue),
                      tooltip: loc.retry ?? 'Regenerate',
                      onPressed: () {
                        final idToUse = pdfId ?? resultId?.toString();
                        if (idToUse != null) {
                          context.read<SummaryBloc>().add(LoadSummary(idToUse));
                        }
                      },
                    );
                  },
                ),
              ],
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
                final summary = _summaryFromState(state);
                if (summary != null) {
                  return TranslatableTextWrapper(
                    targetLang: translationTargetLang,
                    child: CustomScrollView(
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
                              const SizedBox(height: 120),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: BlocBuilder<SummaryBloc, SummaryState>(
              builder: (context, state) {
                final summary = _summaryFromState(state);
                if (summary == null) return const SizedBox.shrink();

                final isDownloading = state is SummaryPdfDownloading;

                return FloatingActionButton.extended(
                  onPressed: isDownloading
                      ? null
                      : () {
                          context.read<SummaryBloc>().add(
                                DownloadSummaryPdf(
                                    pdfId: pdfId ?? resultId!.toString(),
                                    summary: summary,
                                    fileName: fileName,
                                    loc: loc),
                              );
                        },
                  backgroundColor: isDownloading
                      ? (AppColors.isLightMode
                          ? Colors.grey.shade400
                          : AppColors.surface)
                      : AppColors.primaryBlue,
                  elevation: 6,
                  icon: isDownloading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white70),
                          ),
                        )
                      : const Icon(Icons.download_rounded, color: Colors.white),
                  label: Text(
                    isDownloading ? 'Generating PDF…' : 'Download PDF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  dynamic _summaryFromState(SummaryState state) {
    if (state is SummaryLoaded) return state.summary;
    if (state is SummaryPdfDownloading) return state.summary;
    if (state is SummaryPdfDownloaded) return state.summary;
    if (state is SummaryPdfDownloadError) return state.summary;
    return null;
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
            ? AppColors.primaryBlue.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isHighlight
            ? Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3))
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
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 15, height: 1.6),
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
                style: TextStyle(
                  color: AppColors.textPrimary,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.circle,
                          color: AppColors.primaryBlue, size: 8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.replaceAll('**', ''),
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.5),
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
