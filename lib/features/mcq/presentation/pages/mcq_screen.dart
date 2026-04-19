import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/mcq/presentation/manager/mcq_bloc.dart';
import 'package:study_buddy/features/mcq/presentation/pages/quiz_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/processing_status_view.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../../../upload/domain/entities/upload_action.dart';
import '../manager/mcq_event.dart';
import '../manager/mcq_state.dart';

class McqScreen extends StatelessWidget {
  final String pdfId;
  final String fileName;

  const McqScreen({super.key, required this.pdfId, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<McqBloc>(
      create: (BuildContext context) =>
          sl<McqBloc>()..add(GenerateMcqEvent(pdfId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            color: AppColors.leading ?? Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutesName.main,
                arguments: 1,
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MCQ Quiz",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(
                fileName,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )
            ],
          ),
        ),
        body: BlocBuilder<McqBloc, McqState>(
          builder: (context, state) {
            if (state is McqLoading) {
              return ProcessingStatusView(
                action: UploadAction.mcq,
                fileName: "Generating your Quiz...",
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
