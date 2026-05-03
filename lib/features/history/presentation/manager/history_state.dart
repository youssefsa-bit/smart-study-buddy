import '../../domain/entities/history_item.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryItem> historyItems;
  HistoryLoaded(this.historyItems);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
