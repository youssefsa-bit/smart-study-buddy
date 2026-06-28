import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/mcq/presentation/manager/mcq_bloc.dart';
import 'package:study_buddy/features/mcq/presentation/pages/quiz_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/processing_status_view.dart';
import '../../../../core/services/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../upload/domain/entities/upload_action.dart';
import '../manager/mcq_event.dart';
import '../manager/mcq_state.dart';

class McqScreen extends StatelessWidget {
  final String? pdfId;
  final int? resultId;
  final String fileName;

  const McqScreen(
      {super.key, this.pdfId, required this.fileName, this.resultId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider<McqBloc>(
      create: (BuildContext context) {
        final bloc = sl<McqBloc>();

        if (resultId != null) {
          bloc.add(GetExistingMCQ(resultId!));
        } else if (pdfId != null) {
          bloc.add(GenerateMcqEvent(pdfId!));
        }

        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.mcqAppbarTitle,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text(
                fileName,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )
            ],
          ),
          actions: [
            BlocBuilder<McqBloc, McqState>(
              builder: (context, state) {
                if (state is McqLoading) return const SizedBox.shrink();
                return IconButton(
                  icon:
                      Icon(Icons.refresh_rounded, color: AppColors.primaryBlue),
                  tooltip: loc.retry ?? 'Regenerate',
                  onPressed: () {
                    final idToUse = pdfId ?? resultId?.toString();
                    if (idToUse != null) {
                      context.read<McqBloc>().add(GenerateMcqEvent(idToUse));
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<McqBloc, McqState>(
          builder: (context, state) {
            if (state is McqLoading) {
              return ProcessingStatusView(
                action: UploadAction.mcq,
                fileName: loc.mcqGenerating,
                currentStepIndex: state.stepIndex,
              );
            }

            if (state is McqError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              );
            }

            if (state is McqLoaded) {
              return QuizView(quiz: state.quiz);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
