import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_state.dart';
import 'history_item_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.historyUnknownFileType)),
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
              child:  Text(
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryError) {
              return  Center(
                  child: Text(loc.historyNoRecent,
                      style: TextStyle(color: Colors.grey)));
            }

            if (state is HistoryLoaded) {
              if (state.historyItems.isEmpty) {
                return  Center(
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
