import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../flashcards/presentation/pages/flashcard_screen.dart';
import '../../../mcq/presentation/pages/mcq_screen.dart';
import '../../../summary/presentation/pages/summary_screen.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_state.dart';
import '../widgets/history_item_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("History"),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            return ListView.builder(
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
    );
  }
}
