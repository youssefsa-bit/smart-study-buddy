import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';

import '../../../../core/core_widgets/custom_snackbar.dart';
import '../../../../core/routes/app_routes_name.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/history_item.dart';
import '../manager/history_bloc.dart';
import '../manager/history_event.dart';
import '../manager/history_state.dart';
import '../widgets/history_item_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _filterTypes = ['SUMMARY', 'FLASHCARD', 'QUIZ'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  String _filterLabel(BuildContext context, String type) {
    final loc = AppLocalizations.of(context)!;
    switch (type) {
      case 'SUMMARY':
        return loc.historyTypeSummary;
      case 'FLASHCARD':
        return loc.historyTypeFlashcards;
      case 'QUIZ':
        return loc.historyTypeQuiz;
      default:
        return type;
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
              padding: const EdgeInsets.only(
                  top: 24.0, left: 24.0, right: 24.0, bottom: 12.0),
              child: Text(
                loc.historyAppbarTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: loc.historySearchHint,
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (_, value, __) => value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              context
                                  .read<HistoryBloc>()
                                  .add(SearchHistory(''));
                            },
                          ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (query) {
                  context.read<HistoryBloc>().add(SearchHistory(query));
                },
              ),
            ),
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                final activeFilter =
                    state is HistoryLoaded ? state.activeFilter : null;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: loc.historyFilterAll,
                        isSelected: activeFilter == null,
                        onTap: () => context
                            .read<HistoryBloc>()
                            .add(FilterHistoryByType(null)),
                      ),
                      const SizedBox(width: 8),
                      ..._filterTypes.map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _FilterChip(
                            label: _filterLabel(context, type),
                            isSelected: activeFilter == type,
                            onTap: () => context
                                .read<HistoryBloc>()
                                .add(FilterHistoryByType(type)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryBlue));
                  } else if (state is HistoryError) {
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
                            const Icon(Icons.wifi_off_rounded,
                                size: 80, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text(
                              displayError,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 16),
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
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              label: Text(loc.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is HistoryLoaded) {
                    final items = state.filteredItems;
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          state.searchQuery.isNotEmpty ||
                                  state.activeFilter != null
                              ? loc.historyNoResults
                              : loc.historyNoData,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return HistoryItemCard(
                          item: items[index],
                          onTap: () => _navigateToResult(context, items[index]),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
