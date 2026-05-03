import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/history_item.dart';

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

  String _formatType(String type,AppLocalizations loc) {
    if (type == 'QUIZ') return loc.historyTypeQuiz;
    if (type == 'FLASHCARD') return loc.historyTypeFlashcards;
    if (type == 'SUMMARY') return loc.historyTypeSummary;
    return loc.historyTypeDocument;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cleanFileName = item.fileName.replaceAll('.pdf', '');

    return GestureDetector(
      onTap: onTap,
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
            Icon(Icons.more_vert, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
