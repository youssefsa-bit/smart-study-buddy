import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../domain/entities/upload_action.dart';
import '../manager/upload_bloc.dart';
import '../manager/upload_event.dart';
import '../manager/upload_state.dart';
import '../widgets/action_card.dart';
import '../widgets/upload_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UploadBloc>()..add(LoadLibraryEvent()),
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
    if (!context.mounted) return;

    if (result != null) {
      File file = File(result.files.single.path!);
      context.read<UploadBloc>().add(PickFileEvent(file));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state.status == UploadRequestStatus.success &&
                state.resultData != null) {
              final String pdfId = state.resultData!;
              final String fileName = state.selectedPdfId != null
                  ? (state.selectedFileName ?? "Document")
                  : (state.selectedFile?.path.split('/').last ?? "Document");

              final args = {
                'pdfId': pdfId,
                'fileName': fileName,
              };

              if (state.selectedAction == UploadAction.flashcards) {
                Navigator.pushNamed(
                    context, AppRoutesName.flashcards,
                    arguments: args).then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              } else if (state.selectedAction == UploadAction.summarize) {
                Navigator.pushNamed(context, AppRoutesName.summarize,
                    arguments: args).then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              } else if (state.selectedAction == UploadAction.mcq) {
                Navigator.pushNamed(context, AppRoutesName.mcq,
                    arguments: args).then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              }
            } else if (state.status == UploadRequestStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? loc.uploadScreenFailed)),
              );
            }
          },
          builder: (context, state) {
            if (state.status == UploadRequestStatus.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/Uploading.json',
                        width: 150, height: 150),
                    AppSizes.gapV16,
                    Text(
                      loc.uploadScreenProcessing,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24.0, right: 24.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.uploadScreenTitle,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      AppSizes.gapV8,
                      Text(
                        loc.uploadScreenSubtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 15),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UploadBox(
                          selectedFile: state.selectedFile,
                          fileNameFromLibrary: state.selectedFileName,
                          onPickFile: () => _pickFile(context),
                          onRemoveFile: () =>
                              context.read<UploadBloc>().add(RemoveFileEvent()),
                        ),
                        if (state.libraryFiles.isNotEmpty) ...[
                          AppSizes.gapV24,
                          Text(
                            loc.uploadScreenOrChoose,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold),
                          ),
                          AppSizes.gapV16,
                          SizedBox(
                            height: 120,
                              child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.libraryFiles.length,
                              itemBuilder: (context, index) {
                                final file = state.libraryFiles[index];
                                final isSelected = state.selectedPdfId == file.id;

                                return GestureDetector(
                                  onTap: () => context.read<UploadBloc>().add(
                                      SelectLibraryFileEvent(
                                          file.id, file.fileName)),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 110,
                                    margin: const EdgeInsets.only(right: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF101828)
                                          : const Color(0xff111216),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF2E8CFF)
                                            : const Color(0xFF23303F),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color: isSelected
                                              ? const Color(0xFF2E8CFF)
                                              : Colors.redAccent.withValues(alpha: 0.8),
                                          size: 36,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          file.fileName.replaceAll('.pdf', ''),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isSelected
                                                ? const Color(0xFF2E8CFF)
                                                : Colors.white70,
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        AppSizes.gapV24,
                        Text(
                          loc.uploadScreenChooseAction,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold),
                        ),
                        AppSizes.gapV16,
                        ...UploadAction.values.map((action) {
                          return ActionCard(
                            action: action,
                            isSelected: state.selectedAction == action,
                            onTap: () => context
                                .read<UploadBloc>()
                                .add(SelectActionEvent(action)),
                          );
                        }),
                        if ((state.selectedFile != null ||
                            state.selectedPdfId != null) &&
                            state.selectedAction != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 16, bottom: 24),
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
                              child: Text(loc.uploadScreenProcessNow,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}