import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/history_item.dart';
import '../../domain/usecases/delete_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;
  final DeleteHistoryUseCase deleteHistoryUseCase;

  HistoryBloc({
    required this.getHistoryUseCase,
    required this.deleteHistoryUseCase,
  }) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<SearchHistory>(_onSearchHistory);
    on<FilterHistoryByType>(_onFilterHistoryByType);
    on<DeleteHistory>(_onDeleteHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final items = await getHistoryUseCase.call();
      emit(HistoryLoaded(historyItems: items, filteredItems: items));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onSearchHistory(
    SearchHistory event,
    Emitter<HistoryState> emit,
  ) {
    final current = state;
    if (current is! HistoryLoaded) return;

    final filtered = _applyFilters(
      allItems: current.historyItems,
      query: event.query,
      type: current.activeFilter,
    );

    emit(current.copyWith(filteredItems: filtered, searchQuery: event.query));
  }

  void _onFilterHistoryByType(
    FilterHistoryByType event,
    Emitter<HistoryState> emit,
  ) {
    final current = state;
    if (current is! HistoryLoaded) return;

    final filtered = _applyFilters(
      allItems: current.historyItems,
      query: current.searchQuery,
      type: event.type,
    );

    emit(current.copyWith(filteredItems: filtered, activeFilter: event.type));
  }

  Future<void> _onDeleteHistory(
    DeleteHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final current = state;
    if (current is! HistoryLoaded) return;
    emit(current.copyWith(deletingResultId: event.resultId));

    try {
      await deleteHistoryUseCase.call(event.resultId, event.type);

      final updatedAll = current.historyItems
          .where((i) => i.resultId != event.resultId)
          .toList();

      final updatedFiltered = _applyFilters(
        allItems: updatedAll,
        query: current.searchQuery,
        type: current.activeFilter,
      );

      emit(current.copyWith(
        historyItems: updatedAll,
        filteredItems: updatedFiltered,
        deletingResultId: null,
      ));
    } catch (_) {
      emit(current.copyWith(deletingResultId: null));
    }
  }

  List<HistoryItem> _applyFilters({
    required List<HistoryItem> allItems,
    required String query,
    required String? type,
  }) {
    return allItems.where((item) {
      final matchesSearch = query.isEmpty ||
          item.fileName.toLowerCase().contains(query.toLowerCase());
      final matchesType =
          type == null || item.type.toUpperCase() == type.toUpperCase();
      return matchesSearch && matchesType;
    }).toList();
  }
}
