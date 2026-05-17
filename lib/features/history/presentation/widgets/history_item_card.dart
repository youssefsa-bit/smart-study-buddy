import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_event.dart';
import '../manager/history_state.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const HistoryItemCard({super.key, required this.item, required this.onTap});

  Widget _buildIcon() {
    IconData iconData;
    Color color;

    switch (item.type) {
      case 'QUIZ':
        iconData = Icons.help_outline_rounded;
        color = Colors.orangeAccent;
        break;
      case 'FLASHCARD':
        iconData = Icons.style_rounded;
        color = Colors.redAccent;
        break;
      case 'SUMMARY':
      default:
        iconData = Icons.article_rounded;
        color = Colors.blueAccent;
        break;
    }

    return Icon(iconData, color: color, size: 28);
  }

  String _formatDate(DateTime date, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return DateFormat.MMMd(langCode).format(date);
  }

  String _formatType(String type, AppLocalizations loc) {
    if (type == 'QUIZ') return loc.historyTypeQuiz;
    if (type == 'FLASHCARD') return loc.historyTypeFlashcards;
    if (type == 'SUMMARY') return loc.historyTypeSummary;
    return loc.historyTypeDocument;
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
            Offset(button.size.width - 40, button.size.height - 8),
            ancestor: overlay),
        button.localToGlobal(Offset(button.size.width, button.size.height),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded,
                  color: Colors.redAccent, size: 20),
              const SizedBox(width: 10),
              Text(
                // Use your localization key if you add one; hardcoded for now.
                'Delete',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete' && context.mounted) {
        context.read<HistoryBloc>().add(
              DeleteHistory(resultId: item.resultId, type: item.type),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cleanFileName = item.fileName.replaceAll('.pdf', '');

    return BlocBuilder<HistoryBloc, HistoryState>(
      buildWhen: (prev, curr) {
        if (prev is HistoryLoaded && curr is HistoryLoaded) {
          return prev.deletingResultId != curr.deletingResultId;
        }
        return false;
      },
      builder: (context, state) {
        final isDeleting =
            state is HistoryLoaded && state.deletingResultId == item.resultId;

        return GestureDetector(
          onTap: isDeleting ? null : onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isDeleting ? 0.5 : 1.0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cleanFileName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_formatType(item.type, loc)} • ${_formatDate(item.createdAt, context)}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Three-dots button or loading spinner
                  if (isDeleting)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.redAccent,
                      ),
                    )
                  else
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showMenu(context),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:
                            Icon(Icons.more_vert, color: Colors.grey.shade500),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
