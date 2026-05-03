import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.historyUnknownFileType)),
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
                  if (state is HistoryLoaded) {
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