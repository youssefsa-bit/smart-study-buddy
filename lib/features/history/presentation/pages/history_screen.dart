import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_event.dart';
import '../manager/history_state.dart';
import '../widgets/history_item_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _navigateToResult(BuildContext context, HistoryItem item) {
    switch (item.type.toUpperCase()) {
      case 'SUMMARY':
        Navigator.pushNamed(
          context,
          AppRoutesName.summarize,
          arguments: {
            'resultId': item.pdfId,
            'fileName': item.fileName,
          },
        );
        break;
      case 'FLASHCARD':
        Navigator.pushNamed(
          context,
          AppRoutesName.flashcards,
          arguments: {
            'resultId': item.pdfId,
            'fileName': item.fileName,
          },
        );
        break;
      case 'QUIZ':
        Navigator.pushNamed(context, AppRoutesName.mcq, arguments: {
          'resultId': item.pdfId,
          'fileName': item.fileName,
        });
        break;
      default:
        CustomSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.historyUnknownFileType,
          isError: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 8.0),
              child: Text(
                loc.historyAppbarTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                  }
                  else if (state is HistoryError) {
                    String displayError = state.message;
                    final errorStr = state.message.toLowerCase();
                    if (errorStr.contains('connection') ||
                        errorStr.contains('timeout') ||
                        errorStr.contains('network') ||
                        errorStr.contains('socket') ||
                        errorStr.contains('failed')) {
                      displayError = loc.errorNoConnection;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 80, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text(
                              displayError,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                context.read<HistoryBloc>().add(LoadHistory());
                              },
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label:  Text(loc.retry),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  else if (state is HistoryLoaded) {
                    if (state.historyItems.isEmpty) {
                      return Center(
                        child: Text(
                          loc.historyNoData,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: state.historyItems.length,
                      itemBuilder: (context, index) {
                        return HistoryItemCard(
                          item: state.historyItems[index],
                          onTap: () =>
                              _navigateToResult(context, state.historyItems[index]),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}