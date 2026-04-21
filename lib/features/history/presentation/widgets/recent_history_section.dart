import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/mcq/presentation/pages/mcq_screen.dart';

import '../../../flashcards/presentation/pages/flashcard_screen.dart';
import '../../../summary/presentation/pages/summary_screen.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_state.dart';
import 'history_item_card.dart';

class RecentHistorySection extends StatelessWidget {
  const RecentHistorySection({super.key, required this.onDisplayAll});
  final VoidCallback onDisplayAll;
  void _navigateToResult(BuildContext context, HistoryItem item) {
    switch (item.type.toUpperCase()) {
      case 'SUMMARY':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryScreen(
              resultId: item.pdfId,
              fileName: item.fileName,
            ),
          ),
        );
        break;
      case 'FLASHCARD':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardScreen(
              resultId: item.pdfId,
              fileName: item.fileName,
            ),
          ),
        );
        break;
      case 'QUIZ':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                McqScreen(resultId: item.pdfId, fileName: item.fileName),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown file type")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onDisplayAll,
              child: const Text(
                "See all",
                style: TextStyle(color: Color(0xFF2E8CFF), fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryError) {
              return const Center(
                  child: Text("No recent history found.",
                      style: TextStyle(color: Colors.grey)));
            }

            if (state is HistoryLoaded) {
              if (state.historyItems.isEmpty) {
                return const Center(
                    child: Text("No history yet.",
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
