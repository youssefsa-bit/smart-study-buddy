abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class SearchHistory extends HistoryEvent {
  final String query;
  SearchHistory(this.query);
}

class FilterHistoryByType extends HistoryEvent {
  final String? type;
  FilterHistoryByType(this.type);
}

class DeleteHistory extends HistoryEvent {
  final int resultId;
  final String type;
  DeleteHistory({required this.resultId, required this.type});
}
