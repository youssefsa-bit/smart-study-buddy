import '../../domain/entities/history_item.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {

  final List<HistoryItem> historyItems;
  final List<HistoryItem> filteredItems;
  final String searchQuery;
  final String? activeFilter;
  final int? deletingResultId;
  final bool isRefreshing;

  HistoryLoaded({
    required this.historyItems,
    required this.filteredItems,
    this.searchQuery = '',
    this.activeFilter,
    this.deletingResultId,
    this.isRefreshing = false,
  });

  HistoryLoaded copyWith({
    List<HistoryItem>? historyItems,
    List<HistoryItem>? filteredItems,
    String? searchQuery,
    Object? activeFilter = _sentinel,
    Object? deletingResultId = _sentinel,
    bool? isRefreshing,
  }) {
    return HistoryLoaded(
      historyItems: historyItems ?? this.historyItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter == _sentinel
          ? this.activeFilter
          : activeFilter as String?,
      deletingResultId: deletingResultId == _sentinel
          ? this.deletingResultId
          : deletingResultId as int?,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}

const Object _sentinel = Object();
