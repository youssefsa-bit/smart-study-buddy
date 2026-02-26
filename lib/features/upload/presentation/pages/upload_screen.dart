import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/flashcards/presentation/pages/flashcard_screen.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';
import 'package:study_buddy/features/upload/presentation/manager/upload_bloc.dart';
import 'package:study_buddy/features/upload/presentation/manager/upload_state.dart';
import 'package:study_buddy/features/upload/presentation/widgets/action_card.dart';
import 'package:study_buddy/features/upload/presentation/widgets/upload_box.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/app_sizes.dart';
import '../manager/upload_event.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UploadBloc>(),
      child: const _UploadScreenContent(),
    );
  }
}

class _UploadScreenContent extends StatelessWidget {
  const _UploadScreenContent();

  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      context.read<UploadBloc>().add(PickFileEvent(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state.status == UploadRequestStatus.success &&
                state.resultData != null) {
              final String pdfId = state.resultData!;

              if (state.selectedAction == UploadAction.flashcards) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardScreen(pdfId: pdfId),
                  ),
                );
              }
            } else if (state.status == UploadRequestStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? "Upload failed")),
              );
            }
          },
          builder: (context, state) {
            if (state.status == UploadRequestStatus.loading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2E8CFF)),
                    SizedBox(height: 16),
                    Text(
                      "Uploading document...",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.status == UploadRequestStatus.success) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2E8CFF)));
            }

            return Padding(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.gapV16,
                  const Text(
                    "Upload Material",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Add your study material to get started",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  AppSizes.gapV24,
                  UploadBox(
                    selectedFile: state.selectedFile,
                    onPickFile: () => _pickFile(context),
                    onRemoveFile: () =>
                        context.read<UploadBloc>().add(RemoveFileEvent()),
                  ),
                  AppSizes.gapV24,
                  AppSizes.gapV16,
                  const Text(
                    "CHOOSE AN ACTION",
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 20,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  AppSizes.gapV16,
                  Expanded(
                      child: ListView(
                    children: UploadAction.values.map((action) {
                      return ActionCard(
                        action: action,
                        isSelected: state.selectedAction == action,
                        onTap: () => context
                            .read<UploadBloc>()
                            .add(SelectActionEvent(action)),
                      );
                    }).toList(),
                  )),
                  if (state.selectedFile != null &&
                      state.selectedAction != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8CFF),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.read<UploadBloc>().add(ProcessFileEvent());
                        },
                        child: const Text("Process Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
