import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_event.dart';
import '../manager/history_state.dart';
import 'history_item_card.dart';

class RecentHistorySection extends StatelessWidget {
  const RecentHistorySection({super.key, required this.onDisplayAll});
  final VoidCallback onDisplayAll;
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
        Navigator.pushNamed(
          context,
          AppRoutesName.mcq,
          arguments: {
            'resultId': item.pdfId,
            'fileName': item.fileName,
          },
        );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.historyRecent,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onDisplayAll,
              child: Text(
                loc.historySeeAll,
                style: TextStyle(color: Color(0xFF2E8CFF), fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF2E8CFF)),
              ));
            }
            if (state is HistoryError) {
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Colors.grey, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        displayError,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<HistoryBloc>().add(LoadHistory());
                        },
                        icon: const Icon(Icons.refresh,
                            color: Color(0xFF2E8CFF), size: 20),
                        label: Text(
                          loc.retry,
                          style: const TextStyle(color: Color(0xFF2E8CFF)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            if (state is HistoryLoaded) {
              if (state.historyItems.isEmpty) {
                return Center(
                    child: Text(loc.historyNoData,
                        style: TextStyle(color: Colors.grey)));
              }

              final recentItems = state.historyItems.take(2).toList();

              return Column(
                children: recentItems.map((item) {
                  return HistoryItemCard(
                    item: item,
                    onTap: () => _navigateToResult(context, item),
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
