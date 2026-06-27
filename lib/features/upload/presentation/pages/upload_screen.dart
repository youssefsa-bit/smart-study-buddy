import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/app_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/upload_action.dart';
import '../manager/upload_bloc.dart';
import '../manager/upload_event.dart';
import '../manager/upload_state.dart';
import '../widgets/action_card.dart';
import '../widgets/upload_box.dart';

class UploadScreen extends StatelessWidget {
  UploadAction? action;
  UploadScreen({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UploadBloc>()..add(LoadLibraryEvent()),
      child: _UploadScreenContent(action),
    );
  }
}

class _UploadScreenContent extends StatelessWidget {
  UploadAction? action;
  _UploadScreenContent(this.action);

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
    if (action != null) {
      context.read<UploadBloc>().add(SelectActionEvent(action!));
    }
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state.isDuplicate && state.status == UploadRequestStatus.initial && state.selectedAction == null) {
              CustomSnackBar.show(
                context: context,
                message: AppLocalizations.of(context)!.fileAlreadyUploaded,
              );
            }

            if (state.status == UploadRequestStatus.success &&
                state.resultData != null) {
              
              if (state.isDuplicate) {
                CustomSnackBar.show(
                  context: context,
                  message: AppLocalizations.of(context)!.fileAlreadySelected,
                );
              }

              final String pdfId = state.resultData!;
              final String fileName = state.selectedPdfId != null
                  ? (state.selectedFileName ?? "Document")
                  : (state.selectedFile?.path.split('/').last ?? "Document");

              final bool isExistingDoc = state.isDuplicate || state.selectedPdfId != null;
              final args = isExistingDoc
                  ? {
                      'resultId': int.tryParse(pdfId),
                      'fileName': fileName,
                    }
                  : {
                      'pdfId': pdfId,
                      'fileName': fileName,
                    };

              if (state.selectedAction == UploadAction.flashcards) {
                Navigator.pushNamed(context, AppRoutesName.flashcards,
                        arguments: args)
                    .then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              } else if (state.selectedAction == UploadAction.summarize) {
                Navigator.pushNamed(context, AppRoutesName.summarize,
                        arguments: args)
                    .then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              } else if (state.selectedAction == UploadAction.mcq) {
                Navigator.pushNamed(context, AppRoutesName.mcq, arguments: args)
                    .then((_) {
                  if (!context.mounted) return;
                  context.read<UploadBloc>().add(RemoveFileEvent());
                  context.read<UploadBloc>().add(LoadLibraryEvent());
                });
              }
            } else if (state.status == UploadRequestStatus.error) {
              String displayError =
                  state.errorMessage ?? loc.uploadScreenFailed;
              if (state.errorMessage != null) {
                final errorStr = state.errorMessage!.toLowerCase();
                if (errorStr.contains('connection') ||
                    errorStr.contains('timeout') ||
                    errorStr.contains('network') ||
                    errorStr.contains('socket') ||
                    errorStr.contains('failed host lookup')) {
                  displayError = loc.errorNoConnection;
                }
              }
              CustomSnackBar.show(
                context: context,
                message: displayError,
                isError: true,
                customIcon: displayError == loc.errorNoConnection
                    ? Icons.wifi_off_rounded
                    : null,
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
                      style: TextStyle(
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
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      AppSizes.gapV8,
                      Text(
                        loc.uploadScreenSubtitle,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
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
                            style: TextStyle(
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
                                final isSelected =
                                    state.selectedPdfId == file.id;

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
                                          ? AppColors.surface
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                            : AppColors.border,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color: isSelected
                                              ? AppColors.primaryBlue
                                              : Colors.redAccent
                                                  .withValues(alpha: 0.8),
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
                                                ? AppColors.primaryBlue
                                                : AppColors.textSecondary,
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
                          style: TextStyle(
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
                                backgroundColor: AppColors.primaryBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                context
                                    .read<UploadBloc>()
                                    .add(ProcessFileEvent());
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
