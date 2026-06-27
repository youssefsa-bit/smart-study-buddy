import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../../core/core_widgets/custom_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';import '../../domain/entities/history_item.dart';
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

  void _showMenu(BuildContext context, AppLocalizations loc) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final double startX = isRtl ? 0 : button.size.width - 40;
    final double endX = isRtl ? 40 : button.size.width;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(startX, button.size.height - 8),
            ancestor: overlay),
        button.localToGlobal(Offset(endX, button.size.height),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      color: AppColors.surface,
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
                loc.deleteHistoryBtn,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete' && context.mounted) {
        CustomDialog.showConfirmation(
          context: context,
          title: loc.deleteHistoryTitle,
          content: loc.deleteHistoryDesc,
          icon: Icons.delete_outline_rounded,
          iconColor: Colors.redAccent,
          confirmText: loc.deleteHistoryBtn,
          confirmButtonColor: Colors.redAccent,
          onConfirm: () {
            context.read<HistoryBloc>().add(
                  DeleteHistory(resultId: item.resultId, type: item.type),
                );
          },
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
                color: AppColors.surfaceHighlight,
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
                          style: TextStyle(
                            color: AppColors.textPrimary,
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
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      onTap: () => _showMenu(context, loc),
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
